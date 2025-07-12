module "cognito_user_pool" {
  source                 = "../../modules/cognito_user_pool"
  github_repository_name = var.github_repository_name
  env                    = local.env
  user_pool_name         = "user-pool"

  # メールアドレスをサインイン識別子として使用
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  # alias_attributesは削除（username_attributesと競合するため）

  # 基本的なパスワードポリシー
  password_policy = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  # MFA設定（オプション）
  mfa_configuration = "OPTIONAL"

  # アカウント復旧設定（メールアドレスでの復旧）
  account_recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    }
  ]

  # API Gateway用のクライアント設定
  user_pool_clients = [
    {
      name                          = "api-gateway-client"
      generate_secret               = false
      explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
      prevent_user_existence_errors = "ENABLED"
      enable_token_revocation       = true
      access_token_validity         = 60 # 60分
      id_token_validity             = 60 # 60分
      refresh_token_validity        = 30 # 30日
      token_validity_units = {
        access_token  = "minutes"
        id_token      = "minutes"
        refresh_token = "days"
      }
    }
  ]

  tags = {
    Name        = "${var.github_repository_name}-${local.env}-user-pool"
    Environment = local.env
    Project     = var.github_repository_name
  }
}
