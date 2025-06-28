variable "github_owner_name" {
  description = "GitHubオーナー名"
  type        = string
}

variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "iam_openid_connect_provider_arn" {
  description = "IAM OpenID Connect Provider ARN"
  type        = string
}
