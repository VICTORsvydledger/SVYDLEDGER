# Azure Application Insights Module
# SVYD LEDGER - Region: Central US
# Monitoring and Telemetry

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  
  daily_quota_gb = var.daily_quota_gb

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "${var.project_name}-insights-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  
  retention_in_days = var.retention_in_days
  
  sampling_percentage = var.sampling_percentage
  
  disable_ip_masking = false

  tags = var.tags
}

# Smart Detection - Anomaly
resource "azurerm_application_insights_smart_detection_rule" "anomaly" {
  name                    = "Slow page load time"
  application_insights_id = azurerm_application_insights.main.id
  enabled                 = true
  send_emails_to_subscription_owners = true
  additional_email_recipients = var.alert_email_recipients
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.project_name}-alerts-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "svyd-alert"

  email_receiver {
    name          = "admin"
    email_address = var.admin_email
  }

  dynamic "email_receiver" {
    for_each = var.alert_email_recipients
    content {
      name          = "alert-${email_receiver.key}"
      email_address = email_receiver.value
    }
  }

  webhook_receiver {
    name        = "slack"
    service_uri = var.slack_webhook_url != "" ? var.slack_webhook_url : "https://placeholder.webhook.com"
  }

  tags = var.tags
}

# Metric Alerts

# Alert: High Error Rate
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "${var.project_name}-high-error-rate-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when error rate exceeds threshold"
  
  severity = 2
  frequency = "PT5M"
  window_size = "PT15M"
  
  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "exceptions/count"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.error_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Alert: High Response Time
resource "azurerm_monitor_metric_alert" "high_response_time" {
  name                = "${var.project_name}-high-response-time-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when response time exceeds threshold"
  
  severity = 3
  frequency = "PT5M"
  window_size = "PT15M"
  
  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.response_time_threshold_ms
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Alert: High Request Rate
resource "azurerm_monitor_metric_alert" "high_request_rate" {
  name                = "${var.project_name}-high-request-rate-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when request rate exceeds threshold"
  
  severity = 3
  frequency = "PT5M"
  window_size = "PT15M"
  
  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/count"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.request_rate_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Workbook for Dashboard
resource "azurerm_application_insights_workbook" "main" {
  name                = "${var.project_name}-dashboard-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "SVYD LEDGER Dashboard"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests | summarize RequestCount=count() by bin(timestamp, 5m) | render timechart"
          size = 0
          title = "Requests Over Time"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests | summarize AverageDuration=avg(duration) by bin(timestamp, 5m) | render timechart"
          size = 0
          title = "Average Response Time"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "exceptions | summarize ExceptionCount=count() by type | render barchart"
          size = 0
          title = "Exceptions by Type"
        }
      }
    ]
  })

  tags = var.tags
}

# Availability Test (Ping Test)
resource "azurerm_application_insights_standard_web_test" "main" {
  count = var.enable_availability_test ? 1 : 0

  name                    = "${var.project_name}-availability-${var.environment}"
  resource_group_name     = var.resource_group_name
  location                = var.location
  application_insights_id = azurerm_application_insights.main.id
  
  geo_locations = [
    "us-il-ch1-azr",  # Central US
    "us-ca-sjc-azr",  # West US
    "us-va-ash-azr"   # East US
  ]
  
  frequency = 300
  timeout   = 30
  enabled   = true
  
  request {
    url = var.application_url
  }

  tags = var.tags
}
