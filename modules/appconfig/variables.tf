variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "application_name" {
  description = "AppConfigアプリケーション名"
  type        = string
}

variable "application_description" {
  description = "AppConfigアプリケーションの説明"
  type        = string
  default     = ""
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = "AppConfig環境の設定"
  type = map(object({
    description = string
    monitors = optional(list(object({
      alarm_arn      = string
      alarm_role_arn = string
    })))
  }))
  default = {}
}

variable "configuration_profiles" {
  description = "AppConfig設定プロファイルの設定"
  type = map(object({
    description  = string
    location_uri = string
    type         = string
    validators = optional(list(object({
      content = string
      type    = string
    })))
  }))
  default = {}
}

variable "deployment_strategies" {
  description = "AppConfigデプロイメント戦略の設定"
  type = map(object({
    description                    = string
    deployment_duration_in_minutes = number
    final_bake_time_in_minutes     = number
    growth_factor                  = number
    growth_type                    = string
    replicate_to                   = string
  }))
  default = {}
}

variable "hosted_configurations" {
  description = "AppConfigホストされた設定の設定"
  type = map(object({
    profile_name = string
    description  = string
    content_type = string
    content      = string
  }))
  default = {}
}

variable "deployments" {
  description = "AppConfigデプロイメントの設定"
  type = map(object({
    profile_name           = string
    environment_name       = string
    description            = string
    configuration_version  = optional(string)
    hosted_config_name     = optional(string)
    deployment_strategy_id = optional(string)
    strategy_name          = optional(string)
  }))
  default = {}
}
