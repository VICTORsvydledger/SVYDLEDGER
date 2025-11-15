# ACR Module Variables

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "sku" {
  description = "ACR SKU"
  type        = string
  default     = "Premium"
}

variable "retention_days" {
  description = "Image retention days"
  type        = number
  default     = 30
}

variable "aks_principal_id" {
  description = "AKS Managed Identity Principal ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
