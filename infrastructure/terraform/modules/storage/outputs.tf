# Storage Module Outputs
# SVYD LEDGER

output "storage_account_id" {
  description = "Storage account ID"
  value       = var.use_existing_storage ? data.azurerm_storage_account.existing[0].id : azurerm_storage_account.main[0].id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = var.use_existing_storage ? data.azurerm_storage_account.existing[0].name : azurerm_storage_account.main[0].name
}

output "storage_primary_endpoint" {
  description = "Storage primary blob endpoint"
  value       = var.use_existing_storage ? data.azurerm_storage_account.existing[0].primary_blob_endpoint : azurerm_storage_account.main[0].primary_blob_endpoint
}

output "storage_primary_access_key" {
  description = "Storage primary access key"
  value       = var.use_existing_storage ? data.azurerm_storage_account.existing[0].primary_access_key : azurerm_storage_account.main[0].primary_access_key
  sensitive   = true
}

output "containers" {
  description = "Storage containers"
  value = {
    reports = azurerm_storage_container.reports.name
    uploads = azurerm_storage_container.uploads.name
    backups = azurerm_storage_container.backups.name
    logs    = azurerm_storage_container.logs.name
  }
}

output "storage_identity_principal_id" {
  description = "Storage account managed identity principal ID"
  value       = var.use_existing_storage ? null : azurerm_storage_account.main[0].identity[0].principal_id
}
