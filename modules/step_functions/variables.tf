variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "state_machine_name" {
  description = "Step Functionsステートマシンの名前"
  type        = string
}

variable "definition" {
  description = "Step Functionsの定義（JSON文字列）"
  type        = string
}

variable "type" {
  description = "Step Functionsのタイプ（STANDARD または EXPRESS）"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "Type must be either STANDARD or EXPRESS."
  }
}

variable "include_execution_data" {
  description = "実行データをログに含めるかどうか"
  type        = bool
  default     = true
}

variable "log_level" {
  description = "ログレベル（ALL、ERROR、FATAL、OFF）"
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "ERROR", "FATAL", "OFF"], var.log_level)
    error_message = "Log level must be one of: ALL, ERROR, FATAL, OFF."
  }
}

variable "log_retention_in_days" {
  description = "CloudWatch Logsの保持期間（日数）"
  type        = number
  default     = 14
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "custom_policy_statements" {
  description = "カスタムIAMポリシーのステートメント"
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "enable_xray_tracing" {
  description = "X-Rayトレーシングを有効にするかどうか"
  type        = bool
  default     = false
}
