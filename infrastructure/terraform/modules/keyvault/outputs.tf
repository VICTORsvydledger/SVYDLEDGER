# Key Vault Module Outputs
# SVYD LEDGER

output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.main.vault_uri
}

output "database_connection_string_secret_id" {
  description = "Database connection string secret ID"
  value       = azurerm_key_vault_secret.database_connection_string.id
  sensitive   = true
}

output "jwt_secret_key_secret_id" {
  description = "JWT secret key secret ID"
  value       = azurerm_key_vault_secret.jwt_secret.id
  sensitive   = true
}
