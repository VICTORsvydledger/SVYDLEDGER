# API Management Module Outputs
# SVYD LEDGER

output "apim_id" {
  description = "API Management ID"
  value       = azurerm_api_management.main.id
}

output "apim_name" {
  description = "API Management name"
  value       = azurerm_api_management.main.name
}

output "apim_gateway_url" {
  description = "API Management gateway URL"
  value       = azurerm_api_management.main.gateway_url
}

output "apim_gateway_regional_url" {
  description = "API Management gateway regional URL"
  value       = azurerm_api_management.main.gateway_regional_url
}

output "apim_portal_url" {
  description = "API Management developer portal URL"
  value       = azurerm_api_management.main.developer_portal_url
}

output "apim_management_api_url" {
  description = "API Management management API URL"
  value       = azurerm_api_management.main.management_api_url
}

output "apim_public_ip_addresses" {
  description = "API Management public IP addresses"
  value       = azurerm_api_management.main.public_ip_addresses
}

output "apim_identity_principal_id" {
  description = "API Management managed identity principal ID"
  value       = azurerm_api_management.main.identity[0].principal_id
}
