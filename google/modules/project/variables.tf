variable "project_name" {
  description = "The name of the project"
  type        = string
}

# 組織を使う場合は有効化する
# variable "org_id" {
#   description = "The ID of the organization"
#   type        = string
# }

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "default_enabled_services" {
  description = "The list of default enabled services"
  type        = list(string)

  default = [
    # "audit.googleapis.com", # 存在しない
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
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
