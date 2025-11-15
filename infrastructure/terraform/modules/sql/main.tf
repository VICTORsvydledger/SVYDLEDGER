# Azure SQL Hyperscale Module
# SVYD LEDGER - Region: Central US

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "svydserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  
  minimum_tls_version = "1.2"
  
  azuread_administrator {
    login_username = var.azuread_admin_login
    object_id      = var.azuread_admin_object_id
  }

  public_network_access_enabled = true
  
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# SQL Database - Hyperscale
resource "azurerm_mssql_database" "main" {
  name           = "svydledger-hyperescala"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  
  # Hyperscale tier
  sku_name       = "HS_Gen5_2"  # Hyperscale, Gen5, 2 vCores
  zone_redundant = false
  
  # Automatic tuning
  auto_pause_delay_in_minutes = -1  # Disabled for Hyperscale
  
  # Threat detection
  threat_detection_policy {
    state                      = "Enabled"
    email_account_admins       = "Enabled"
    retention_days             = 30
  }

  tags = var.tags
}

# Firewall Rules
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall rule for AKS (will be updated with actual AKS IP range)
resource "azurerm_mssql_firewall_rule" "allow_aks" {
  name             = "AllowAKS"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.aks_outbound_ip_start
  end_ip_address   = var.aks_outbound_ip_end
}

# Auditing to Storage Account
resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  server_id                               = azurerm_mssql_server.main.id
  storage_endpoint                        = var.storage_account_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
  log_monitoring_enabled                  = true
}

# Transparent Data Encryption (TDE)
resource "azurerm_mssql_database_extended_auditing_policy" "main" {
  database_id                             = azurerm_mssql_database.main.id
  storage_endpoint                        = var.storage_account_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
  log_monitoring_enabled                  = true
}

# Vulnerability Assessment
resource "azurerm_mssql_server_security_alert_policy" "main" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.main.name
  state               = "Enabled"
  
  email_account_admins = true
  email_addresses      = var.security_alert_emails
  retention_days       = 30
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "sql_server" {
  name                       = "sql-diagnostics"
  target_resource_id         = azurerm_mssql_server.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "sql_database" {
  name                       = "database-diagnostics"
  target_resource_id         = azurerm_mssql_database.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "SQLInsights"
  }

  enabled_log {
    category = "AutomaticTuning"
  }

  enabled_log {
    category = "QueryStoreRuntimeStatistics"
  }

  enabled_log {
    category = "QueryStoreWaitStatistics"
  }

  enabled_log {
    category = "Errors"
  }

  enabled_log {
    category = "DatabaseWaitStatistics"
  }

  enabled_log {
    category = "Timeouts"
  }

  enabled_log {
    category = "Blocks"
  }

  enabled_log {
    category = "Deadlocks"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
