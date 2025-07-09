variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "role_name" {
  description = "ロール名"
  type        = string
}

variable "policy" {
  description = "IAMポリシー"
  type        = string
}

variable "enable_xray" {
  description = "X-Rayトレーシングを有効にするかどうか"
  type        = bool
  default     = false
}
