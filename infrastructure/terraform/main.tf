# Terraform Main Configuration
# SVYD LEDGER - Universal Accounting System
# Region: Central US

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45"
    }
  }

  # Backend para almacenar el estado en Azure
  backend "azurerm" {
    resource_group_name  = "svydledger-data"
    storage_account_name = "svydledgerstore"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# Variables locales
locals {
  project_name = "svydledger"
  region       = "centralus"  # Región parametrizada
  environment  = var.environment
  
  common_tags = {
    Project     = "SVYD LEDGER"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Region      = local.region
  }
}

# Grupo de recursos (ya existe, usar data source)
data "azurerm_resource_group" "main" {
  name = "svydledger-data"
}

# Module: Application Insights (debe ser primero para Log Analytics)
module "app_insights" {
  source              = "./modules/app-insights"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = local.region
  environment         = local.environment
  project_name        = local.project_name
  admin_email         = var.admin_email
  alert_email_recipients = var.alert_email_recipients
  application_url     = var.environment == "prod" ? "https://www.svydledger.com" : "https://${var.environment}.svydledger.com"
  tags                = local.common_tags
}

# Module: Storage
module "storage" {
  source                     = "./modules/storage"
  resource_group_name        = data.azurerm_resource_group.main.name
  location                   = local.region
  environment                = local.environment
  project_name               = local.project_name
  use_existing_storage       = var.environment == "prod"
  log_analytics_workspace_id = module.app_insights.log_analytics_workspace_id
  tags                       = local.common_tags
}

# Module: AKS
module "aks" {
  source              = "./modules/aks"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = local.region
  environment         = local.environment
  project_name        = local.project_name
  tags                = local.common_tags
}

# Module: ACR
module "acr" {
  source              = "./modules/acr"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = local.region
  environment         = local.environment
  project_name        = local.project_name
  tags                = local.common_tags
}

# Module: SQL
module "sql" {
  source                      = "./modules/sql"
  resource_group_name         = data.azurerm_resource_group.main.name
  location                    = local.region
  environment                 = local.environment
  project_name                = local.project_name
  sql_admin_username          = var.sql_admin_username
  sql_admin_password          = var.sql_admin_password
  storage_account_endpoint    = module.storage.storage_primary_endpoint
  storage_account_access_key  = module.storage.storage_primary_access_key
  log_analytics_workspace_id  = module.app_insights.log_analytics_workspace_id
  security_alert_emails       = var.alert_email_recipients
  tags                        = local.common_tags
}

# Module: Key Vault
module "keyvault" {
  source                            = "./modules/keyvault"
  resource_group_name               = data.azurerm_resource_group.main.name
  location                          = local.region
  environment                       = local.environment
  project_name                      = local.project_name
  aks_identity_principal_id         = module.aks.kubelet_identity_object_id
  sql_server_identity_principal_id  = module.sql.sql_server_identity_principal_id
  database_connection_string        = module.sql.connection_string
  jwt_secret_key                    = var.jwt_secret_key
  stripe_secret_key                 = var.stripe_secret_key
  stripe_webhook_secret             = var.stripe_webhook_secret
  log_analytics_workspace_id        = module.app_insights.log_analytics_workspace_id
  tags                              = local.common_tags
  
  depends_on = [module.aks, module.sql]
}

# Module: Service Bus
module "service_bus" {
  source                     = "./modules/service-bus"
  resource_group_name        = data.azurerm_resource_group.main.name
  location                   = local.region
  environment                = local.environment
  project_name               = local.project_name
  sku                        = var.environment == "prod" ? "Premium" : "Standard"
  log_analytics_workspace_id = module.app_insights.log_analytics_workspace_id
  tags                       = local.common_tags
}

# Module: API Management
module "api_management" {
  source                                  = "./modules/api-management"
  resource_group_name                     = data.azurerm_resource_group.main.name
  location                                = local.region
  environment                             = local.environment
  project_name                            = local.project_name
  publisher_email                         = var.admin_email
  sku_name                                = var.environment == "prod" ? "Premium_1" : "Developer_1"
  identity_service_url                    = "http://identity-service"
  accounting_service_url                  = "http://accounting-service"
  reports_service_url                     = "http://reports-service"
  payments_service_url                    = "http://payments-service"
  frontend_url                            = var.environment == "prod" ? "https://www.svydledger.com" : "https://${var.environment}.svydledger.com"
  log_analytics_workspace_id              = module.app_insights.log_analytics_workspace_id
  application_insights_id                 = module.app_insights.application_insights_id
  application_insights_instrumentation_key = module.app_insights.instrumentation_key
  tags                                    = local.common_tags
}
