variable "gke_project" {
  description = "Name of GKE project"
  type        = string
}

variable "region" {
  type        = string
  description = "region"
  default     = "asia-northeast1"
}

variable "service_name" {
  type = string
}

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
  description = "Viewers of the microservice"

  type    = list(string)
  default = []
}

variable "service_admins" {
  description = "Admins of the microservice"

  type    = list(string)
  default = []
}

variable "environment" {
  description = "Environment of the microservice"

  type = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be dev or prod."
  }
}
