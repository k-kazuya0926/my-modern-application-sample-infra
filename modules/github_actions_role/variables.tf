variable "github_owner_name" {
  description = "GitHub のオーナー名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "env" {
  description = "環境"
  type        = string
}

variable "iam_openid_connect_provider_arn" {
  description = "IAM OpenID Connect Provider ARN"
  type        = string
}
