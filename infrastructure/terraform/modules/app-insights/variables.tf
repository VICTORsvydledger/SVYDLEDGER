# App Insights Module Variables
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

variable "retention_in_days" {
  description = "Data retention in days"
  type        = number
  default     = 90
  
  validation {
    condition     = contains([30, 60, 90, 120, 180, 270, 365, 550, 730], var.retention_in_days)
    error_message = "Retention must be 30, 60, 90, 120, 180, 270, 365, 550, or 730 days."
  }
}

variable "daily_quota_gb" {
  description = "Daily ingestion quota in GB"
  type        = number
  default     = 10
}

variable "sampling_percentage" {
  description = "Sampling percentage (0-100)"
  type        = number
  default     = 100
  
  validation {
    condition     = var.sampling_percentage >= 0 && var.sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }
}

variable "admin_email" {
  description = "Admin email for alerts"
  type        = string
}

variable "alert_email_recipients" {
  description = "Additional email recipients for alerts"
  type        = list(string)
  default     = []
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for alerts"
  type        = string
  sensitive   = true
  default     = ""
}

variable "error_threshold" {
  description = "Error count threshold for alerts"
  type        = number
  default     = 100
}

variable "response_time_threshold_ms" {
  description = "Response time threshold in milliseconds"
  type        = number
  default     = 3000
}

variable "request_rate_threshold" {
  description = "Request rate threshold"
  type        = number
  default     = 10000
}

variable "enable_availability_test" {
  description = "Enable availability test"
  type        = bool
  default     = true
}

variable "application_url" {
  description = "Application URL for availability test"
  type        = string
  default     = "https://www.svydledger.com"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
