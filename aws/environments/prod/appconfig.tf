# AppConfig for Feature Flags
module "appconfig_feature_flags" {
  source = "../../modules/appconfig"

  github_repository_name = var.github_repository_name
  env                    = local.env

  # Application設定
  application_name        = "feature-flags"
  application_description = "Feature flags for the application"

  # Configuration Profile設定
  configuration_profile_name        = "feature-flags"
  configuration_profile_description = "Feature flags configuration profile"
  configuration_profile_type        = "AWS.AppConfig.FeatureFlags"

  # ホスト型設定を作成してflag1機能フラグを定義
  create_hosted_configuration       = true
  hosted_configuration_content_type = "application/json"
  hosted_configuration_content = jsonencode({
    flags = {
      flag1 = {
        name    = "flag1"
        enabled = true
        variants = {
          on = {
            value = true
          }
          off = {
            value = false
          }
        }
        defaultVariant = "on"
      }
    }
    values = {
      flag1 = {
        enabled = true
      }
    }
    version = "1"
  })
  hosted_configuration_description = "Initial feature flags configuration with flag1"

  # デプロイメント戦略を作成（即座にロールアウト）
  create_deployment_strategy      = true
  deployment_strategy_name        = "immediate-rollout"
  deployment_strategy_description = "Immediate rollout strategy for feature flags"
  deployment_duration_in_minutes  = 0
  final_bake_time_in_minutes      = 0
  growth_factor                   = 100
  growth_type                     = "EXPONENTIAL"

  # デプロイメントを作成
  create_deployment      = true
  deployment_description = "Initial deployment of feature flags"
}
