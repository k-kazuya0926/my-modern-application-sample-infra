variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "additional_enabled_services" {
  description = "The list of additional enabled services"
  type        = list(string)

  default = []
}

variable "service_viewers" {
  description = "The list of service viewers"
  type        = list(string)

  default = []
}

variable "service_admins" {
  description = "The list of service admins"
  type        = list(string)

  default = []
}

variable "region" {
  description = "The region of the GKE cluster"
  type        = string
  default     = "asia-northeast1"
}

variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "environment" {
  description = "The environment of the microservice"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be one of dev or prod."
  }
}
