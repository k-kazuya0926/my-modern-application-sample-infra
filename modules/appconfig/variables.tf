# 基本設定
variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

# Application設定
variable "application_name" {
  description = "AppConfigアプリケーション名"
  type        = string
}

variable "application_description" {
  description = "AppConfigアプリケーションの説明"
  type        = string
  default     = ""
}

# Environment設定
variable "environment_description" {
  description = "AppConfig環境の説明"
  type        = string
  default     = ""
}

variable "monitors" {
  description = "AppConfig環境のモニター設定"
  type = list(object({
    alarm_arn      = string
    alarm_role_arn = string
  }))
  default = []
}

# Configuration Profile設定
variable "configuration_profile_name" {
  description = "Configuration Profile名"
  type        = string
}

variable "configuration_profile_description" {
  description = "Configuration Profileの説明"
  type        = string
  default     = ""
}

variable "location_uri" {
  description = "設定データの場所URI"
  type        = string
  default     = "hosted"
}

variable "configuration_profile_type" {
  description = "Configuration Profileのタイプ"
  type        = string
  default     = "AWS.AppConfig.FeatureFlags"
  validation {
    condition = contains([
      "AWS.AppConfig.FeatureFlags",
      "AWS.Freeform"
    ], var.configuration_profile_type)
    error_message = "Configuration profile type must be either 'AWS.AppConfig.FeatureFlags' or 'AWS.Freeform'."
  }
}

variable "validators" {
  description = "Configuration Profileのバリデーター設定"
  type = list(object({
    content = string
    type    = string
  }))
  default = []
}

# Deployment Strategy設定
variable "create_deployment_strategy" {
  description = "デプロイメント戦略を作成するかどうか"
  type        = bool
  default     = false
}

variable "deployment_strategy_name" {
  description = "デプロイメント戦略名"
  type        = string
  default     = "default-strategy"
}

variable "deployment_strategy_description" {
  description = "デプロイメント戦略の説明"
  type        = string
  default     = ""
}

variable "deployment_duration_in_minutes" {
  description = "デプロイメント期間（分）"
  type        = number
  default     = 0
}

variable "final_bake_time_in_minutes" {
  description = "最終ベイク時間（分）"
  type        = number
  default     = 0
}

variable "growth_factor" {
  description = "成長率"
  type        = number
  default     = 100
}

variable "growth_type" {
  description = "成長タイプ"
  type        = string
  default     = "EXPONENTIAL"
  validation {
    condition = contains([
      "EXPONENTIAL",
      "LINEAR"
    ], var.growth_type)
    error_message = "Growth type must be either 'EXPONENTIAL' or 'LINEAR'."
  }
}

variable "replicate_to" {
  description = "レプリケート先"
  type        = string
  default     = "NONE"
  validation {
    condition = contains([
      "NONE",
      "SSM_DOCUMENT"
    ], var.replicate_to)
    error_message = "Replicate to must be either 'NONE' or 'SSM_DOCUMENT'."
  }
}

# Hosted Configuration設定
variable "create_hosted_configuration" {
  description = "ホスト型設定を作成するかどうか"
  type        = bool
  default     = false
}

variable "hosted_configuration_content_type" {
  description = "ホスト型設定のコンテンツタイプ"
  type        = string
  default     = "application/json"
}

variable "hosted_configuration_content" {
  description = "ホスト型設定のコンテンツ"
  type        = string
  default     = "{}"
}

variable "hosted_configuration_description" {
  description = "ホスト型設定の説明"
  type        = string
  default     = ""
}

# Deployment設定
variable "create_deployment" {
  description = "デプロイメントを作成するかどうか"
  type        = bool
  default     = false
}

variable "configuration_version" {
  description = "設定バージョン（ホスト型設定を使用しない場合）"
  type        = string
  default     = "1"
}

variable "deployment_strategy_id" {
  description = "既存のデプロイメント戦略ID（新規作成しない場合）"
  type        = string
  default     = ""
}

variable "deployment_description" {
  description = "デプロイメントの説明"
  type        = string
  default     = ""
}

# タグ設定
variable "tags" {
  description = "リソースに適用するタグ"
  type        = map(string)
  default     = {}
}
