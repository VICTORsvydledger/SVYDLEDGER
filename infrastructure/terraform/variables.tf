# Terraform Variables
# SVYD LEDGER - Central US

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralus"
  
  validation {
    condition     = var.location == "centralus"
    error_message = "Location must be centralus for SVYD LEDGER."
  }
}

# SQL Variables
variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.sql_admin_password) >= 12
    error_message = "SQL admin password must be at least 12 characters long."
  }
}

# Security Variables
variable "jwt_secret_key" {
  description = "JWT secret key for authentication"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.jwt_secret_key) >= 32
    error_message = "JWT secret key must be at least 32 characters long."
  }
}

# Stripe Variables
variable "stripe_secret_key" {
  description = "Stripe API secret key"
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

# Alert and Monitoring Variables
variable "admin_email" {
  description = "Administrator email for alerts and notifications"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "Must be a valid email address."
  }
}

variable "alert_email_recipients" {
  description = "Additional email recipients for alerts"
  type        = list(string)
  default     = []
}

# Tags
variable "additional_tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}
