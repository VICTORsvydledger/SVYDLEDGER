# Key Vault Module Variables
# SVYD LEDGER

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region (centralus)"
  type        = string
  default     = "centralus"
}

variable "environment" {
  description = "Environment (dev, stage, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "svydledger"
}

variable "aks_identity_principal_id" {
  description = "AKS managed identity principal ID"
  type        = string
  default     = ""
}

variable "sql_server_identity_principal_id" {
  description = "SQL Server managed identity principal ID"
  type        = string
  default     = ""
}

variable "database_connection_string" {
  description = "Database connection string"
  type        = string
  sensitive   = true
}

variable "jwt_secret_key" {
  description = "JWT secret key"
  type        = string
  sensitive   = true
}

variable "stripe_secret_key" {
  description = "Stripe secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "stripe_webhook_secret" {
  description = "Stripe webhook secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "allowed_ip_addresses" {
  description = "Allowed IP addresses for Key Vault access"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "Allowed subnet IDs for Key Vault access"
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
