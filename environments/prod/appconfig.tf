module "appconfig" {
  source = "../../modules/appconfig"

  github_repository_name  = var.github_repository_name
  env                     = local.env
  application_name        = "feature-flags"
  application_description = "Application feature flags management"

  # AppConfig環境
  environments = {
    "${local.env}" = {
      description = ""
      monitors    = null
    }
  }

  # 機能フラグ設定プロファイル
  configuration_profiles = {
    feature-flags = {
      description  = "Feature flags configuration"
      location_uri = "hosted"
      type         = "AWS.AppConfig.FeatureFlags"
      validators   = null
    }
  }

  # デプロイメント戦略
  deployment_strategies = {
    immediate = {
      description                    = "Immediate deployment"
      deployment_duration_in_minutes = 0
      final_bake_time_in_minutes     = 0
      growth_factor                  = 100
      growth_type                    = "LINEAR"
      replicate_to                   = "NONE"
    }
  }

  # 機能フラグの初期設定
  hosted_configurations = {
    initial-flags = {
      profile_name = "feature-flags"
      description  = "Initial feature flags configuration"
      content_type = "application/json"
      content = jsonencode({
        flags = {
          new_user_registration = {
            name    = "new_user_registration"
            enabled = true
            variants = {
              enabled = {
                value = true
              }
              disabled = {
                value = false
              }
            }
          }
          email_notifications = {
            name    = "email_notifications"
            enabled = true
            variants = {
              enabled = {
                value = true
              }
              disabled = {
                value = false
              }
            }
          }
          s3_read_feature = {
            name    = "s3_read_feature"
            enabled = true
            variants = {
              enabled = {
                value = true
              }
              disabled = {
                value = false
              }
            }
          }
        }
        values = {
          new_user_registration = {
            enabled = true
          }
          email_notifications = {
            enabled = true
          }
          s3_read_feature = {
            enabled = true
          }
        }
        version = "1"
      })
    }
  }

  # デプロイメント設定
  deployments = {
    initial-deployment = {
      profile_name       = "feature-flags"
      environment_name   = local.env
      description        = "Initial feature flags deployment"
      hosted_config_name = "initial-flags"
      strategy_name      = "immediate"
    }
  }

  tags = {
    Environment = local.env
    Project     = var.github_repository_name
    Service     = "AppConfig"
    Purpose     = "FeatureFlags"
  }
}
