variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.github_repository_name))
    error_message = "GitHubリポジトリ名は小文字、数字、ハイフンのみ使用可能で、先頭と末尾はハイフン以外である必要があります。"
  }
}

variable "env" {
  description = "環境名"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "環境名は dev, staging, prod のいずれかである必要があります。"
  }
}

variable "bucket_name" {
  description = "バケット名"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "バケット名は小文字、数字、ハイフンのみ使用可能で、先頭と末尾はハイフン以外である必要があります。"
  }
}

variable "bucket_purpose" {
  description = "バケットの用途（タグ付けに使用）"
  type        = string
  default     = "general"
}

variable "force_destroy" {
  description = "バケット内にオブジェクトがある場合でも削除を許可するかどうか"
  type        = bool
  default     = false
}

variable "tags" {
  description = "バケットに適用する追加タグ"
  type        = map(string)
  default     = {}
}

# セキュリティ設定
variable "block_public_acls" {
  description = "パブリックACLをブロックするかどうか"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "パブリックバケットポリシーをブロックするかどうか"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "パブリックACLを無視するかどうか"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "パブリックバケットアクセスを制限するかどうか"
  type        = bool
  default     = true
}

# 暗号化設定
variable "kms_master_key_id" {
  description = "KMS暗号化に使用するキーID（null の場合はAES256を使用）"
  type        = string
  default     = null

  validation {
    condition     = var.kms_master_key_id == null || can(regex("^(arn:aws:kms:|alias/|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*$", var.kms_master_key_id))
    error_message = "KMSキーIDは有効なARN、エイリアス、またはキーIDである必要があります。"
  }
}

variable "bucket_key_enabled" {
  description = "S3バケットキーを有効にするかどうか（KMS暗号化のコスト削減）"
  type        = bool
  default     = true
}

# バージョニング設定
variable "versioning_enabled" {
  description = "バージョニングを有効にするかどうか"
  type        = bool
  default     = false
}

# ライフサイクル設定
variable "lifecycle_rules" {
  description = "ライフサイクルルールのリスト"
  type = list(object({
    id     = string
    status = string
    expiration = optional(object({
      days = number
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })))
  }))
  default = []
}

# CORS設定
variable "cors_rules" {
  description = "CORS設定のリスト"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

# バケットポリシー
variable "bucket_policy" {
  description = "バケットポリシーのJSON文字列"
  type        = string
  default     = null
}

# ログ設定
variable "logging_target_bucket" {
  description = "アクセスログの保存先バケット名"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "アクセスログのプレフィックス"
  type        = string
  default     = "access-logs/"
}

# 通知設定
variable "lambda_notifications" {
  description = "Lambda関数への通知設定"
  type = list(object({
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = optional(string)
    filter_suffix       = optional(string)
  }))
  default = []
}

variable "sqs_notifications" {
  description = "SQSキューへの通知設定"
  type = list(object({
    queue_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

variable "sns_notifications" {
  description = "SNSトピックへの通知設定"
  type = list(object({
    topic_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}
