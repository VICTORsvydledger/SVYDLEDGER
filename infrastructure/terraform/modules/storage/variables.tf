# Storage Module Variables
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

variable "use_existing_storage" {
  description = "Use existing svydledgerstore storage account"
  type        = bool
  default     = true
}

variable "replication_type" {
  description = "Storage replication type"
  type        = string
  default     = "LRS"
  
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Must be LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "allowed_ip_addresses" {
  description = "Allowed IP addresses for storage access"
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "Allowed subnet IDs for storage access"
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Storage"
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
