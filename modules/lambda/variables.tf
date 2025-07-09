variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "function_name" {
  description = "Lambda関数の名前"
  type        = string
}

variable "execution_role_arn" {
  description = "Lambda実行ロールのARN"
  type        = string
}

variable "image_uri" {
  description = "コンテナイメージのURI（ECRリポジトリのURI）"
  type        = string
}

variable "memory_size" {
  description = "Lambda関数のメモリサイズ（MB）"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Lambda関数のタイムアウト（秒）"
  type        = number
  default     = 3
}

variable "environment_variables" {
  description = "Lambda関数の環境変数"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日）"
  type        = number
  default     = 7

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.log_retention_days)
    error_message = "log_retention_days は有効なCloudWatch Logsの保持期間である必要があります。"
  }
}

variable "s3_trigger_bucket_name" {
  description = "S3トリガーのバケット名（オプション）"
  type        = string
  default     = null
}

variable "s3_trigger_bucket_arn" {
  description = "S3トリガーのバケットARN（オプション）"
  type        = string
  default     = null
}

variable "s3_trigger_events" {
  description = "S3トリガーのイベント種類"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}

variable "sqs_trigger_queue_arn" {
  description = "SQSトリガーのキューARN（オプション）"
  type        = string
  default     = null
}

variable "sqs_trigger_batch_size" {
  description = "SQSトリガーのバッチサイズ"
  type        = number
  default     = 10
}

variable "enable_tracing" {
  description = "X-Rayトレーシングを有効にするかどうか"
  type        = bool
  default     = false
}
