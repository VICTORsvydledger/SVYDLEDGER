# Azure Service Bus Module
# SVYD LEDGER - Region: Central US
# Event-Driven Architecture

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = "${var.project_name}-sb-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku  # Standard or Premium
  
  capacity = var.sku == "Premium" ? var.capacity : 0
  
  zone_redundant = var.sku == "Premium" ? true : false
  
  # Premium features
  premium_messaging_partitions = var.sku == "Premium" ? var.premium_messaging_partitions : 0

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Topics for Event-Driven Architecture

# Topic: Journal Entries
resource "azurerm_servicebus_topic" "journal_entries" {
  name         = "journal-entries"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  enable_partitioning = true
  max_size_in_megabytes = var.sku == "Premium" ? 81920 : 5120
  
  # Message retention
  default_message_ttl = "P14D"  # 14 days
  
  # Duplicate detection
  requires_duplicate_detection = true
  duplicate_detection_history_time_window = "PT10M"
}

# Subscriptions for journal-entries topic
resource "azurerm_servicebus_subscription" "journal_entries_reports" {
  name               = "reports-service"
  topic_id           = azurerm_servicebus_topic.journal_entries.id
  max_delivery_count = 10
  
  # Auto-delete after 14 days of inactivity
  auto_delete_on_idle = "P14D"
  
  # Lock duration for message processing
  lock_duration = "PT5M"
}

resource "azurerm_servicebus_subscription" "journal_entries_accounting" {
  name               = "accounting-service"
  topic_id           = azurerm_servicebus_topic.journal_entries.id
  max_delivery_count = 10
  auto_delete_on_idle = "P14D"
  lock_duration = "PT5M"
}

# Topic: Invoices
resource "azurerm_servicebus_topic" "invoices" {
  name         = "invoices"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  enable_partitioning = true
  max_size_in_megabytes = var.sku == "Premium" ? 81920 : 5120
  default_message_ttl = "P14D"
  requires_duplicate_detection = true
  duplicate_detection_history_time_window = "PT10M"
}

resource "azurerm_servicebus_subscription" "invoices_payments" {
  name               = "payments-service"
  topic_id           = azurerm_servicebus_topic.invoices.id
  max_delivery_count = 10
  auto_delete_on_idle = "P14D"
  lock_duration = "PT5M"
}

resource "azurerm_servicebus_subscription" "invoices_reports" {
  name               = "reports-service"
  topic_id           = azurerm_servicebus_topic.invoices.id
  max_delivery_count = 10
  auto_delete_on_idle = "P14D"
  lock_duration = "PT5M"
}

# Topic: Payments
resource "azurerm_servicebus_topic" "payments" {
  name         = "payments"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  enable_partitioning = true
  max_size_in_megabytes = var.sku == "Premium" ? 81920 : 5120
  default_message_ttl = "P14D"
  requires_duplicate_detection = true
  duplicate_detection_history_time_window = "PT10M"
}

resource "azurerm_servicebus_subscription" "payments_accounting" {
  name               = "accounting-service"
  topic_id           = azurerm_servicebus_topic.payments.id
  max_delivery_count = 10
  auto_delete_on_idle = "P14D"
  lock_duration = "PT5M"
}

resource "azurerm_servicebus_subscription" "payments_reports" {
  name               = "reports-service"
  topic_id           = azurerm_servicebus_topic.payments.id
  max_delivery_count = 10
  auto_delete_on_idle = "P14D"
  lock_duration = "PT5M"
}

# Topic: User Events
resource "azurerm_servicebus_topic" "user_events" {
  name         = "user-events"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  enable_partitioning = true
  max_size_in_megabytes = var.sku == "Premium" ? 81920 : 5120
  default_message_ttl = "P7D"  # 7 days for user events
  requires_duplicate_detection = true
  duplicate_detection_history_time_window = "PT10M"
}

resource "azurerm_servicebus_subscription" "user_events_all" {
  name               = "all-services"
  topic_id           = azurerm_servicebus_topic.user_events.id
  max_delivery_count = 5
  auto_delete_on_idle = "P14D"
  lock_duration = "PT2M"
}

# Authorization Rules

# Listen-only rule for services
resource "azurerm_servicebus_namespace_authorization_rule" "listen" {
  name         = "service-listen"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  listen = true
  send   = false
  manage = false
}

# Send-only rule for services
resource "azurerm_servicebus_namespace_authorization_rule" "send" {
  name         = "service-send"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  listen = false
  send   = true
  manage = false
}

# Full access for management
resource "azurerm_servicebus_namespace_authorization_rule" "manage" {
  name         = "service-manage"
  namespace_id = azurerm_servicebus_namespace.main.id
  
  listen = true
  send   = true
  manage = true
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "servicebus" {
  name                       = "servicebus-diagnostics"
  target_resource_id         = azurerm_servicebus_namespace.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "OperationalLogs"
  }

  enabled_log {
    category = "RuntimeAuditLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Private Endpoint (for Premium SKU)
resource "azurerm_private_endpoint" "servicebus" {
  count = var.enable_private_endpoint && var.sku == "Premium" ? 1 : 0

  name                = "${var.project_name}-sb-pe-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-sb-psc-${var.environment}"
    private_connection_resource_id = azurerm_servicebus_namespace.main.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  tags = var.tags
}
