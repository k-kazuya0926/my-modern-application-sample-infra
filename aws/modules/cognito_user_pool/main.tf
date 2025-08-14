resource "aws_cognito_user_pool" "this" {
  name = "${var.github_repository_name}-${var.env}-${var.user_pool_name}"

  # エイリアス設定
  # alias_attributes と username_attributes は競合するため、username_attributes のみを使用
  auto_verified_attributes = var.auto_verified_attributes
  username_attributes      = var.username_attributes

  # パスワードポリシー
  password_policy {
    minimum_length                   = var.password_policy.minimum_length
    require_lowercase                = var.password_policy.require_lowercase
    require_numbers                  = var.password_policy.require_numbers
    require_symbols                  = var.password_policy.require_symbols
    require_uppercase                = var.password_policy.require_uppercase
    temporary_password_validity_days = var.password_policy.temporary_password_validity_days
  }

  # MFA設定
  mfa_configuration = var.mfa_configuration

  dynamic "software_token_mfa_configuration" {
    for_each = var.mfa_configuration != "OFF" ? [1] : []
    content {
      enabled = true
    }
  }

  # ユーザー属性スキーマ
  dynamic "schema" {
    for_each = var.schema_attributes
    content {
      name                     = schema.value.name
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = lookup(schema.value, "developer_only_attribute", false)
      mutable                  = lookup(schema.value, "mutable", true)
      required                 = lookup(schema.value, "required", false)

      dynamic "string_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "String" ? [1] : []
        content {
          min_length = lookup(schema.value, "min_length", 0)
          max_length = lookup(schema.value, "max_length", 2048)
        }
      }

      dynamic "number_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "Number" ? [1] : []
        content {
          min_value = lookup(schema.value, "min_value", 0)
          max_value = lookup(schema.value, "max_value", 2147483647)
        }
      }
    }
  }

  # アカウント復旧設定
  dynamic "account_recovery_setting" {
    for_each = var.account_recovery_mechanisms != null ? [1] : []
    content {
      dynamic "recovery_mechanism" {
        for_each = var.account_recovery_mechanisms
        content {
          name     = recovery_mechanism.value.name
          priority = recovery_mechanism.value.priority
        }
      }
    }
  }

  # 管理者作成ユーザー設定
  dynamic "admin_create_user_config" {
    for_each = var.admin_create_user_config != null ? [1] : []
    content {
      allow_admin_create_user_only = var.admin_create_user_config.allow_admin_create_user_only

      dynamic "invite_message_template" {
        for_each = var.admin_create_user_config.invite_message_template != null ? [1] : []
        content {
          email_message = var.admin_create_user_config.invite_message_template.email_message
          email_subject = var.admin_create_user_config.invite_message_template.email_subject
          sms_message   = var.admin_create_user_config.invite_message_template.sms_message
        }
      }
    }
  }

  # デバイス設定
  dynamic "device_configuration" {
    for_each = var.device_configuration != null ? [1] : []
    content {
      challenge_required_on_new_device      = var.device_configuration.challenge_required_on_new_device
      device_only_remembered_on_user_prompt = var.device_configuration.device_only_remembered_on_user_prompt
    }
  }

  # メール設定
  dynamic "email_configuration" {
    for_each = var.email_configuration != null ? [1] : []
    content {
      configuration_set      = var.email_configuration.configuration_set
      email_sending_account  = var.email_configuration.email_sending_account
      from_email_address     = var.email_configuration.from_email_address
      reply_to_email_address = var.email_configuration.reply_to_email_address
      source_arn             = var.email_configuration.source_arn
    }
  }

  # SMS設定
  dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [1] : []
    content {
      external_id    = var.sms_configuration.external_id
      sns_caller_arn = var.sms_configuration.sns_caller_arn
      sns_region     = var.sms_configuration.sns_region
    }
  }

  # ユーザープールアドオン
  dynamic "user_pool_add_ons" {
    for_each = var.advanced_security_mode != null ? [1] : []
    content {
      advanced_security_mode = var.advanced_security_mode
    }
  }

  # 検証メッセージテンプレート
  dynamic "verification_message_template" {
    for_each = var.verification_message_template != null ? [1] : []
    content {
      default_email_option  = var.verification_message_template.default_email_option
      email_message         = var.verification_message_template.email_message
      email_message_by_link = var.verification_message_template.email_message_by_link
      email_subject         = var.verification_message_template.email_subject
      email_subject_by_link = var.verification_message_template.email_subject_by_link
      sms_message           = var.verification_message_template.sms_message
    }
  }

  # Lambdaトリガー
  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [1] : []
    content {
      create_auth_challenge          = var.lambda_config.create_auth_challenge
      custom_message                 = var.lambda_config.custom_message
      define_auth_challenge          = var.lambda_config.define_auth_challenge
      post_authentication            = var.lambda_config.post_authentication
      post_confirmation              = var.lambda_config.post_confirmation
      pre_authentication             = var.lambda_config.pre_authentication
      pre_sign_up                    = var.lambda_config.pre_sign_up
      pre_token_generation           = var.lambda_config.pre_token_generation
      user_migration                 = var.lambda_config.user_migration
      verify_auth_challenge_response = var.lambda_config.verify_auth_challenge_response
    }
  }

  tags = var.tags
}

# ユーザープールクライアント
resource "aws_cognito_user_pool_client" "this" {
  count = length(var.user_pool_clients)

  name         = "${var.github_repository_name}-${var.env}-${var.user_pool_clients[count.index].name}"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                               = var.user_pool_clients[count.index].generate_secret
  allowed_oauth_flows                           = var.user_pool_clients[count.index].allowed_oauth_flows
  allowed_oauth_flows_user_pool_client          = var.user_pool_clients[count.index].allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes                          = var.user_pool_clients[count.index].allowed_oauth_scopes
  callback_urls                                 = var.user_pool_clients[count.index].callback_urls
  default_redirect_uri                          = var.user_pool_clients[count.index].default_redirect_uri
  explicit_auth_flows                           = var.user_pool_clients[count.index].explicit_auth_flows
  logout_urls                                   = var.user_pool_clients[count.index].logout_urls
  read_attributes                               = var.user_pool_clients[count.index].read_attributes
  write_attributes                              = var.user_pool_clients[count.index].write_attributes
  supported_identity_providers                  = var.user_pool_clients[count.index].supported_identity_providers
  prevent_user_existence_errors                 = var.user_pool_clients[count.index].prevent_user_existence_errors
  enable_token_revocation                       = var.user_pool_clients[count.index].enable_token_revocation
  enable_propagate_additional_user_context_data = var.user_pool_clients[count.index].enable_propagate_additional_user_context_data

  # トークン有効期限設定
  dynamic "token_validity_units" {
    for_each = var.user_pool_clients[count.index].token_validity_units != null ? [1] : []
    content {
      access_token  = var.user_pool_clients[count.index].token_validity_units.access_token
      id_token      = var.user_pool_clients[count.index].token_validity_units.id_token
      refresh_token = var.user_pool_clients[count.index].token_validity_units.refresh_token
    }
  }

  access_token_validity  = var.user_pool_clients[count.index].access_token_validity
  id_token_validity      = var.user_pool_clients[count.index].id_token_validity
  refresh_token_validity = var.user_pool_clients[count.index].refresh_token_validity

  depends_on = [aws_cognito_user_pool.this]
}

# ユーザープールドメイン（オプション）
resource "aws_cognito_user_pool_domain" "this" {
  count = var.user_pool_domain != null ? 1 : 0

  domain          = var.user_pool_domain.domain
  certificate_arn = var.user_pool_domain.certificate_arn
  user_pool_id    = aws_cognito_user_pool.this.id

  depends_on = [aws_cognito_user_pool.this]
}

# アイデンティティプロバイダー（オプション）
resource "aws_cognito_identity_provider" "this" {
  count = length(var.identity_providers)

  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = var.identity_providers[count.index].provider_name
  provider_type = var.identity_providers[count.index].provider_type

  provider_details  = var.identity_providers[count.index].provider_details
  attribute_mapping = var.identity_providers[count.index].attribute_mapping

  depends_on = [aws_cognito_user_pool.this]
}
