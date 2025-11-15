# API Management Module Variables
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

variable "publisher_name" {
  description = "Publisher name"
  type        = string
  default     = "SVYD LEDGER"
}

variable "publisher_email" {
  description = "Publisher email"
  type        = string
}

variable "sku_name" {
  description = "API Management SKU"
  type        = string
  default     = "Developer_1"
  
  validation {
    condition     = can(regex("^(Developer_1|Basic_[12]|Standard_[12]|Premium_[0-9]+)$", var.sku_name))
    error_message = "Invalid SKU name format."
  }
}

variable "virtual_network_type" {
  description = "Virtual network type (None, Internal, External)"
  type        = string
  default     = "None"
  
  validation {
    condition     = contains(["None", "Internal", "External"], var.virtual_network_type)
    error_message = "Must be None, Internal, or External."
  }
}

variable "subnet_id" {
  description = "Subnet ID for VNet integration"
  type        = string
  default     = ""
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "certificates" {
  description = "Certificates for APIM"
  type = list(object({
    encoded_certificate = string
    store_name          = string
  }))
  default = []
}

# Backend service URLs
variable "identity_service_url" {
  description = "Identity service backend URL"
  type        = string
  default     = "http://identity-service"
}

variable "accounting_service_url" {
  description = "Accounting service backend URL"
  type        = string
  default     = "http://accounting-service"
}

variable "reports_service_url" {
  description = "Reports service backend URL"
  type        = string
  default     = "http://reports-service"
}

variable "payments_service_url" {
  description = "Payments service backend URL"
  type        = string
  default     = "http://payments-service"
}

variable "frontend_url" {
  description = "Frontend URL for CORS"
  type        = string
  default     = "https://www.svydledger.com"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "application_insights_id" {
  description = "Application Insights ID"
  type        = string
  default     = ""
}

variable "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  type        = string
  sensitive   = true
  default     = ""
}

# Custom domain
variable "enable_custom_domain" {
  description = "Enable custom domain"
  type        = bool
  default     = false
}

variable "custom_domain_gateway" {
  description = "Custom domain for API gateway"
  type        = string
  default     = "api.svydledger.com"
}

variable "custom_domain_portal" {
  description = "Custom domain for developer portal"
  type        = string
  default     = ""
}

variable "custom_domain_certificate" {
  description = "Certificate for custom domain"
  type        = string
  sensitive   = true
  default     = ""
}

variable "custom_domain_certificate_password" {
  description = "Certificate password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
