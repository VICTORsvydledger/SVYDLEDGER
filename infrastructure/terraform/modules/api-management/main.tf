# Azure API Management Module
# SVYD LEDGER - Region: Central US
# API Gateway

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# API Management
resource "azurerm_api_management" "main" {
  name                = "${var.project_name}-apim-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  
  sku_name = var.sku_name  # Developer_1, Basic_1, Standard_1, Premium_1
  
  identity {
    type = "SystemAssigned"
  }

  # Virtual Network integration (for Premium/Developer SKU)
  virtual_network_type = var.virtual_network_type  # None, Internal, External
  
  dynamic "virtual_network_configuration" {
    for_each = var.subnet_id != "" ? [1] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  # Security
  min_api_version = "2021-08-01"
  
  # Certificates
  dynamic "certificate" {
    for_each = var.certificates
    content {
      encoded_certificate = certificate.value.encoded_certificate
      store_name          = certificate.value.store_name
    }
  }

  # Protocols
  protocols {
    enable_http2 = true
  }

  # Additional settings
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# API - Identity Service
resource "azurerm_api_management_api" "identity" {
  name                = "identity-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Identity Service API"
  path                = "identity"
  protocols           = ["https"]
  
  service_url = var.identity_service_url
  
  subscription_required = true
  
  import {
    content_format = "openapi+json"
    content_value  = jsonencode({
      openapi = "3.0.0"
      info = {
        title   = "Identity Service"
        version = "1.0"
      }
      paths = {
        "/auth/login" = {
          post = {
            summary = "User login"
          }
        }
        "/auth/register" = {
          post = {
            summary = "User registration"
          }
        }
        "/users/me" = {
          get = {
            summary = "Get current user"
          }
        }
      }
    })
  }
}

# API - Accounting Service
resource "azurerm_api_management_api" "accounting" {
  name                = "accounting-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Accounting Service API"
  path                = "accounting"
  protocols           = ["https"]
  
  service_url = var.accounting_service_url
  
  subscription_required = true
}

# API - Reports Service
resource "azurerm_api_management_api" "reports" {
  name                = "reports-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Reports Service API"
  path                = "reports"
  protocols           = ["https"]
  
  service_url = var.reports_service_url
  
  subscription_required = true
}

# API - Payments Service
resource "azurerm_api_management_api" "payments" {
  name                = "payments-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Payments Service API"
  path                = "payments"
  protocols           = ["https"]
  
  service_url = var.payments_service_url
  
  subscription_required = true
}

# Global Policy - CORS
resource "azurerm_api_management_policy" "global" {
  api_management_id = azurerm_api_management.main.id
  
  xml_content = <<XML
<policies>
  <inbound>
    <cors allow-credentials="true">
      <allowed-origins>
        <origin>${var.frontend_url}</origin>
        <origin>https://www.svydledger.com</origin>
        <origin>https://dev.svydledger.com</origin>
      </allowed-origins>
      <allowed-methods>
        <method>GET</method>
        <method>POST</method>
        <method>PUT</method>
        <method>DELETE</method>
        <method>PATCH</method>
        <method>OPTIONS</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
    <rate-limit-by-key calls="100" renewal-period="60" counter-key="@(context.Request.IpAddress)" />
  </inbound>
  <backend>
    <forward-request timeout="30" />
  </backend>
  <outbound>
    <set-header name="X-Powered-By" exists-action="delete" />
    <set-header name="X-AspNet-Version" exists-action="delete" />
  </outbound>
  <on-error>
    <set-body>@{
      return new JObject(
        new JProperty("error", context.LastError.Message),
        new JProperty("timestamp", DateTime.UtcNow.ToString("o"))
      ).ToString();
    }</set-body>
  </on-error>
</policies>
XML
}

# Product - Free Tier
resource "azurerm_api_management_product" "free" {
  product_id            = "free"
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = var.resource_group_name
  display_name          = "Free"
  description           = "Free tier for SVYD LEDGER"
  subscription_required = true
  approval_required     = false
  published             = true
  
  subscriptions_limit = 1
}

# Product - Premium Tier
resource "azurerm_api_management_product" "premium" {
  product_id            = "premium"
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = var.resource_group_name
  display_name          = "Premium"
  description           = "Premium tier for SVYD LEDGER"
  subscription_required = true
  approval_required     = false
  published             = true
  
  subscriptions_limit = 10
}

# Link APIs to Products
resource "azurerm_api_management_product_api" "free_identity" {
  api_name            = azurerm_api_management_api.identity.name
  product_id          = azurerm_api_management_product.free.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_api" "premium_accounting" {
  api_name            = azurerm_api_management_api.accounting.name
  product_id          = azurerm_api_management_product.premium.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "apim" {
  name                       = "apim-diagnostics"
  target_resource_id         = azurerm_api_management.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "GatewayLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Logger to Application Insights
resource "azurerm_api_management_logger" "appinsights" {
  count = var.application_insights_id != "" ? 1 : 0

  name                = "app-insights-logger"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
  
  application_insights {
    instrumentation_key = var.application_insights_instrumentation_key
  }
}

# Custom Domain (optional)
resource "azurerm_api_management_custom_domain" "main" {
  count = var.enable_custom_domain ? 1 : 0

  api_management_id = azurerm_api_management.main.id

  gateway {
    host_name    = var.custom_domain_gateway
    certificate  = var.custom_domain_certificate
    certificate_password = var.custom_domain_certificate_password
  }

  dynamic "developer_portal" {
    for_each = var.custom_domain_portal != "" ? [1] : []
    content {
      host_name = var.custom_domain_portal
      certificate  = var.custom_domain_certificate
      certificate_password = var.custom_domain_certificate_password
    }
  }
}
