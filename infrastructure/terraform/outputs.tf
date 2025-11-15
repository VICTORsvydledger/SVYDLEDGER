# Terraform Outputs
# SVYD LEDGER

# Resource Group
output "resource_group_name" {
  description = "Resource group name"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = data.azurerm_resource_group.main.location
}

# AKS
output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "AKS cluster ID"
  value       = module.aks.cluster_id
}

output "aks_kube_config_command" {
  description = "Command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${data.azurerm_resource_group.main.name} --name ${module.aks.cluster_name}"
}

# ACR
output "acr_login_server" {
  description = "ACR login server"
  value       = module.acr.login_server
}

output "acr_name" {
  description = "ACR name"
  value       = module.acr.name
}

# SQL
output "sql_server_fqdn" {
  description = "SQL Server FQDN"
  value       = module.sql.sql_server_fqdn
}

output "sql_database_name" {
  description = "SQL Database name"
  value       = module.sql.sql_database_name
}

output "sql_connection_string_info" {
  description = "SQL connection string information (without password)"
  value       = "Server=tcp:${module.sql.sql_server_fqdn},1433;Database=${module.sql.sql_database_name};User ID=${var.sql_admin_username};Encrypt=true"
}

# Key Vault
output "key_vault_name" {
  description = "Key Vault name"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.keyvault.key_vault_uri
}

# Service Bus
output "servicebus_namespace_name" {
  description = "Service Bus namespace name"
  value       = module.service_bus.servicebus_namespace_name
}

output "servicebus_endpoint" {
  description = "Service Bus endpoint"
  value       = module.service_bus.servicebus_endpoint
}

output "servicebus_topics" {
  description = "Service Bus topics"
  value       = module.service_bus.topics
}

# API Management
output "apim_gateway_url" {
  description = "API Management gateway URL"
  value       = module.api_management.apim_gateway_url
}

output "apim_portal_url" {
  description = "API Management developer portal URL"
  value       = module.api_management.apim_portal_url
}

output "apim_name" {
  description = "API Management name"
  value       = module.api_management.apim_name
}

# Storage
output "storage_account_name" {
  description = "Storage account name"
  value       = module.storage.storage_account_name
}

output "storage_containers" {
  description = "Storage containers"
  value       = module.storage.containers
}

# Application Insights
output "application_insights_name" {
  description = "Application Insights name"
  value       = module.app_insights.application_insights_name
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = module.app_insights.instrumentation_key
  sensitive   = true
}

output "log_analytics_workspace_name" {
  description = "Log Analytics workspace name"
  value       = module.app_insights.log_analytics_workspace_name
}

# Deployment Information
output "deployment_summary" {
  description = "Deployment summary"
  value = {
    environment = var.environment
    region      = local.region
    project     = local.project_name
    aks_cluster = module.aks.cluster_name
    sql_server  = module.sql.sql_server_fqdn
    api_gateway = module.api_management.apim_gateway_url
    monitoring  = module.app_insights.application_insights_name
  }
}

# Next Steps
output "next_steps" {
  description = "Next steps after deployment"
  value = <<-EOT
  
  ========================================
  ?? SVYD LEDGER Infrastructure Deployed!
  ========================================
  
  Region: ${local.region}
  Environment: ${var.environment}
  
  ?? NEXT STEPS:
  
  1. Connect to AKS:
     az aks get-credentials --resource-group ${data.azurerm_resource_group.main.name} --name ${module.aks.cluster_name}
  
  2. Verify cluster:
     kubectl get nodes
  
  3. Create Kubernetes secrets:
     kubectl create secret generic app-secrets \
       --from-literal=database-url="${module.sql.connection_string}" \
       --from-literal=jwt-secret="${var.jwt_secret_key}" \
       --namespace=production
  
  4. Deploy services:
     kubectl apply -f ../kubernetes/base/
  
  5. Check API Gateway:
     ${module.api_management.apim_gateway_url}
  
  6. View monitoring:
     https://portal.azure.com/#resource${module.app_insights.application_insights_id}
  
  ========================================
  
  EOT
}
