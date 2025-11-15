# SQL Module Variables
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

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "azuread_admin_login" {
  description = "Azure AD administrator login"
  type        = string
  default     = ""
}

variable "azuread_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
  default     = ""
}

variable "aks_outbound_ip_start" {
  description = "AKS outbound IP range start"
  type        = string
  default     = "0.0.0.0"
}

variable "aks_outbound_ip_end" {
  description = "AKS outbound IP range end"
  type        = string
  default     = "255.255.255.255"
}

variable "storage_account_endpoint" {
  description = "Storage account endpoint for auditing"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage account access key"
  type        = string
  sensitive   = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "security_alert_emails" {
  description = "Email addresses for security alerts"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
