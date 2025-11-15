# Azure Storage Module
# SVYD LEDGER - Region: Central US
# Blob Storage for reports, files, and backups

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Storage Account (already exists, use data source)
data "azurerm_storage_account" "existing" {
  count = var.use_existing_storage ? 1 : 0
  
  name                = "svydledgerstore"
  resource_group_name = var.resource_group_name
}

# Or create new Storage Account
resource "azurerm_storage_account" "main" {
  count = var.use_existing_storage ? 0 : 1

  name                     = "${var.project_name}store${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  
  # Security
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  
  # Blob properties
  blob_properties {
    versioning_enabled = true
    
    change_feed_enabled = true
    
    delete_retention_policy {
      days = 30
    }
    
    container_delete_retention_policy {
      days = 30
    }
  }

  # Network rules
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.allowed_ip_addresses
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

locals {
  storage_account_name = var.use_existing_storage ? data.azurerm_storage_account.existing[0].name : azurerm_storage_account.main[0].name
  storage_account_id   = var.use_existing_storage ? data.azurerm_storage_account.existing[0].id : azurerm_storage_account.main[0].id
}

# Containers

# Container for reports (PDF, Excel, CSV)
resource "azurerm_storage_container" "reports" {
  name                  = "reports"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Container for user uploads
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Container for backups
resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Container for terraform state (already exists if using existing storage)
resource "azurerm_storage_container" "tfstate" {
  count = var.use_existing_storage ? 0 : 1

  name                  = "tfstate"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Container for logs
resource "azurerm_storage_container" "logs" {
  name                  = "logs"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Lifecycle Management Policy
resource "azurerm_storage_management_policy" "main" {
  storage_account_id = local.storage_account_id

  rule {
    name    = "reports-lifecycle"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["reports/"]
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
      
      snapshot {
        delete_after_days_since_creation_greater_than = 90
      }
    }
  }

  rule {
    name    = "backups-lifecycle"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["backups/"]
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 7
        tier_to_archive_after_days_since_modification_greater_than = 30
        delete_after_days_since_modification_greater_than          = 90
      }
    }
  }

  rule {
    name    = "logs-lifecycle"
    enabled = true
    
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["logs/"]
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 14
        delete_after_days_since_modification_greater_than          = 60
      }
    }
  }
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "storage-diagnostics"
  target_resource_id         = local.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Blob Service Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "blob" {
  name               = "blob-diagnostics"
  target_resource_id = "${local.storage_account_id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Private Endpoint
resource "azurerm_private_endpoint" "storage" {
  count = var.enable_private_endpoint ? 1 : 0

  name                = "${var.project_name}-storage-pe-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-storage-psc-${var.environment}"
    private_connection_resource_id = local.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags
}
