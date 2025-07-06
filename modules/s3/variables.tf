variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "bucket_name" {
  description = "バケット名"
  type        = string
}

variable "force_destroy" {
  description = "バケット内にオブジェクトがある場合でも削除を許可するかどうか"
  type        = bool
  default     = false
}
