variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "ecr_repository_name" {
  description = "ECRリポジトリ名"
  type        = string
}

variable "image_tag_mutability" {
  description = "イメージタグの変更設定"
  type        = string
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "イメージタグの変更設定はMUTABLEまたはIMMUTABLEである必要があります。"
  }
}

variable "scan_on_push" {
  description = "イメージがリポジトリにプッシュされた後にスキャンされるかどうか"
  type        = bool
  default     = true
}

variable "lifecycle_policy_enabled" {
  description = "ライフサイクルポリシーを有効にするかどうか"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "保持する最大イメージ数"
  type        = number
  default     = 5
}
