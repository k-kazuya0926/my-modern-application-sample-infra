variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "api_name" {
  description = "API Gateway の名前"
  type        = string
}

variable "description" {
  description = "API Gateway の説明"
  type        = string
  default     = ""
}

variable "stage_name" {
  description = "API Gateway のステージ名"
  type        = string
  default     = "v1"
}

variable "cors_configuration" {
  description = "CORS設定"
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(list(string), ["*"])
    allow_methods     = optional(list(string), ["*"])
    allow_origins     = optional(list(string), ["*"])
    expose_headers    = optional(list(string), [])
    max_age           = optional(number, 86400)
  })
  default = {
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    expose_headers    = []
    max_age           = 86400
  }
}

variable "routes" {
  description = "API Gateway のルート設定"
  type = list(object({
    route_key = string
  }))
  default = []
}

variable "integrations" {
  description = "API Gateway の統合設定"
  type = list(object({
    integration_uri    = string
    integration_type   = string
    integration_method = string
  }))
  default = []
}

variable "lambda_permissions" {
  description = "Lambda関数への許可設定"
  type = list(object({
    function_name = string
  }))
  default = []
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

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}
