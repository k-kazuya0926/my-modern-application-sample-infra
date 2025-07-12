# SPA用のCognitoユーザープール
module "cognito_user_pool_spa" {
  source = "../../modules/cognito_user_pool"

  github_repository_name = var.github_repository_name
  env                    = local.env
  user_pool_name         = "default"

  # メールアドレスでのサインインを許可
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # パスワードポリシー（SPA用に適度な強度）
  password_policy = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false # SPA用に記号を必須にしない
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  # MFA設定（SPA用にオプション）
  mfa_configuration = "OPTIONAL"

  # アカウント復旧設定
  account_recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    }
  ]

  # メール設定（SES使用）
  email_configuration = {
    email_sending_account  = "DEVELOPER"
    from_email_address     = var.mail_from
    reply_to_email_address = var.mail_from
    source_arn             = module.ses.email_identity_arns[0]
  }

  # 検証メッセージテンプレート
  verification_message_template = {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_subject         = "アカウントの確認"
    email_message_by_link = "アカウントを確認するには、以下のリンクをクリックしてください: {##Click Here##}"
  }

  # SPA用のクライアント設定
  user_pool_clients = [
    {
      name                                 = "spa"
      generate_secret                      = false    # SPAはパブリッククライアント
      allowed_oauth_flows                  = ["code"] # PKCE付き認証コードフロー（推奨）
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes                 = ["openid", "email", "profile"]
      callback_urls                        = ["http://localhost:3000/callback", "https://your-spa-domain.com/callback"]
      logout_urls                          = ["http://localhost:3000/", "https://your-spa-domain.com/"]
      explicit_auth_flows = [
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_AUTH"
      ]
      supported_identity_providers  = ["COGNITO"]
      prevent_user_existence_errors = "ENABLED"
      enable_token_revocation       = true

      # トークン有効期限設定
      access_token_validity  = 60 # 1時間
      id_token_validity      = 60 # 1時間
      refresh_token_validity = 5  # 5日
      token_validity_units = {
        access_token  = "minutes"
        id_token      = "minutes"
        refresh_token = "days"
      }
    }
  ]

  # ホストドメイン設定（オプション）
  user_pool_domain = {
    domain = "${var.github_repository_name}"
  }
}
