# Service Bus Module Outputs
# SVYD LEDGER

output "servicebus_namespace_id" {
  description = "Service Bus namespace ID"
  value       = azurerm_servicebus_namespace.main.id
}

output "servicebus_namespace_name" {
  description = "Service Bus namespace name"
  value       = azurerm_servicebus_namespace.main.name
}

output "servicebus_endpoint" {
  description = "Service Bus endpoint"
  value       = azurerm_servicebus_namespace.main.endpoint
}

output "servicebus_listen_connection_string" {
  description = "Service Bus listen connection string"
  value       = azurerm_servicebus_namespace_authorization_rule.listen.primary_connection_string
  sensitive   = true
}

output "servicebus_send_connection_string" {
  description = "Service Bus send connection string"
  value       = azurerm_servicebus_namespace_authorization_rule.send.primary_connection_string
  sensitive   = true
}

output "servicebus_manage_connection_string" {
  description = "Service Bus manage connection string"
  value       = azurerm_servicebus_namespace_authorization_rule.manage.primary_connection_string
  sensitive   = true
}

output "topics" {
  description = "Service Bus topics"
  value = {
    journal_entries = azurerm_servicebus_topic.journal_entries.name
    invoices        = azurerm_servicebus_topic.invoices.name
    payments        = azurerm_servicebus_topic.payments.name
    user_events     = azurerm_servicebus_topic.user_events.name
  }
}
