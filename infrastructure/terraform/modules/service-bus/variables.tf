# Service Bus Module Variables
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

variable "sku" {
  description = "Service Bus SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "capacity" {
  description = "Messaging units for Premium SKU (1, 2, 4, 8, 16)"
  type        = number
  default     = 1
  
  validation {
    condition     = contains([1, 2, 4, 8, 16], var.capacity)
    error_message = "Capacity must be 1, 2, 4, 8, or 16."
  }
}

variable "premium_messaging_partitions" {
  description = "Number of partitions for Premium SKU (1, 2, 4)"
  type        = number
  default     = 1
  
  validation {
    condition     = contains([1, 2, 4], var.premium_messaging_partitions)
    error_message = "Premium messaging partitions must be 1, 2, or 4."
  }
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Service Bus"
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
