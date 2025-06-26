variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "env" {
  description = "環境"
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
