# Azure Container Registry (ACR) Module

resource "azurerm_container_registry" "main" {
  name                = "${var.project_name}acr${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = false  # Usar Managed Identity
  
  # Security: Disable anonymous pull
  anonymous_pull_enabled = false
  
  # Network rules
  public_network_access_enabled = true
  
  network_rule_bypass_option = "AzureServices"

  # Retention policy
  retention_policy {
    days    = var.retention_days
    enabled = true
  }

  # Trust policy
  trust_policy {
    enabled = true
  }

  tags = var.tags
}

# Grant AKS access to ACR using Managed Identity
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.aks_principal_id != null ? 1 : 0
  principal_id         = var.aks_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.main.id
}

# Outputs
output "login_server" {
  value = azurerm_container_registry.main.login_server
}

output "id" {
  value = azurerm_container_registry.main.id
}

output "name" {
  value = azurerm_container_registry.main.name
}
