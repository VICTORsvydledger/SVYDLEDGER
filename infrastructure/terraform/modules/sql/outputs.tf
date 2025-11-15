# SQL Module Outputs
# SVYD LEDGER

output "sql_server_id" {
  description = "SQL Server ID"
  value       = azurerm_mssql_server.main.id
}

output "sql_server_fqdn" {
  description = "SQL Server FQDN"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_server_name" {
  description = "SQL Server name"
  value       = azurerm_mssql_server.main.name
}

output "sql_database_id" {
  description = "SQL Database ID"
  value       = azurerm_mssql_database.main.id
}

output "sql_database_name" {
  description = "SQL Database name"
  value       = azurerm_mssql_database.main.name
}

output "connection_string" {
  description = "SQL Database connection string (without password)"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.main.name};User ID=${var.sql_admin_username};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
  sensitive   = true
}

output "sql_server_identity_principal_id" {
  description = "SQL Server managed identity principal ID"
  value       = azurerm_mssql_server.main.identity[0].principal_id
}
