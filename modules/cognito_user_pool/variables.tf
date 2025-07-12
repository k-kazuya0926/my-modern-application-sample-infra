variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "user_pool_name" {
  description = "Cognitoユーザープール名"
  type        = string
}

variable "alias_attributes" {
  description = "ユーザーのサインインに使用できるエイリアス属性"
  type        = list(string)
  default     = []
}

variable "auto_verified_attributes" {
  description = "自動検証される属性"
  type        = list(string)
  default     = []
}

variable "username_attributes" {
  description = "ユーザー名として使用できる属性"
  type        = list(string)
  default     = []
}

variable "password_policy" {
  description = "パスワードポリシー設定"
  type = object({
    minimum_length                   = number
    require_lowercase                = bool
    require_numbers                  = bool
    require_symbols                  = bool
    require_uppercase                = bool
    temporary_password_validity_days = number
  })
  default = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}

variable "mfa_configuration" {
  description = "MFA設定 (OFF, ON, OPTIONAL)"
  type        = string
  default     = "OPTIONAL"
  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "MFA設定は OFF, ON, OPTIONAL のいずれかである必要があります。"
  }
}

variable "schema_attributes" {
  description = "カスタム属性スキーマ"
  type = list(object({
    name                     = string
    attribute_data_type      = string
    developer_only_attribute = optional(bool)
    mutable                  = optional(bool)
    required                 = optional(bool)
    min_length               = optional(number)
    max_length               = optional(number)
    min_value                = optional(number)
    max_value                = optional(number)
  }))
  default = []
}

variable "account_recovery_mechanisms" {
  description = "アカウント復旧メカニズム"
  type = list(object({
    name     = string
    priority = number
  }))
  default = null
}

variable "admin_create_user_config" {
  description = "管理者作成ユーザー設定"
  type = object({
    allow_admin_create_user_only = bool
    invite_message_template = optional(object({
      email_message = string
      email_subject = string
      sms_message   = string
    }))
  })
  default = null
}

variable "device_configuration" {
  description = "デバイス設定"
  type = object({
    challenge_required_on_new_device      = bool
    device_only_remembered_on_user_prompt = bool
  })
  default = null
}

variable "email_configuration" {
  description = "メール設定"
  type = object({
    configuration_set      = optional(string)
    email_sending_account  = string
    from_email_address     = optional(string)
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
  })
  default = null
}

variable "sms_configuration" {
  description = "SMS設定"
  type = object({
    external_id    = string
    sns_caller_arn = string
    sns_region     = optional(string)
  })
  default = null
}

variable "advanced_security_mode" {
  description = "高度なセキュリティモード (OFF, AUDIT, ENFORCED)"
  type        = string
  default     = null
  validation {
    condition     = var.advanced_security_mode == null || contains(["OFF", "AUDIT", "ENFORCED"], var.advanced_security_mode)
    error_message = "高度なセキュリティモードは OFF, AUDIT, ENFORCED のいずれかである必要があります。"
  }
}

variable "verification_message_template" {
  description = "検証メッセージテンプレート"
  type = object({
    default_email_option  = optional(string)
    email_message         = optional(string)
    email_message_by_link = optional(string)
    email_subject         = optional(string)
    email_subject_by_link = optional(string)
    sms_message           = optional(string)
  })
  default = null
}

variable "lambda_config" {
  description = "Lambda設定"
  type = object({
    create_auth_challenge          = optional(string)
    custom_message                 = optional(string)
    define_auth_challenge          = optional(string)
    post_authentication            = optional(string)
    post_confirmation              = optional(string)
    pre_authentication             = optional(string)
    pre_sign_up                    = optional(string)
    pre_token_generation           = optional(string)
    user_migration                 = optional(string)
    verify_auth_challenge_response = optional(string)
  })
  default = null
}

variable "user_pool_clients" {
  description = "ユーザープールクライアント設定"
  type = list(object({
    name                                          = string
    generate_secret                               = optional(bool, false)
    allowed_oauth_flows                           = optional(list(string), [])
    allowed_oauth_flows_user_pool_client          = optional(bool, false)
    allowed_oauth_scopes                          = optional(list(string), [])
    callback_urls                                 = optional(list(string), [])
    default_redirect_uri                          = optional(string)
    explicit_auth_flows                           = optional(list(string), [])
    logout_urls                                   = optional(list(string), [])
    read_attributes                               = optional(list(string), [])
    write_attributes                              = optional(list(string), [])
    supported_identity_providers                  = optional(list(string), [])
    prevent_user_existence_errors                 = optional(string, "ENABLED")
    enable_token_revocation                       = optional(bool, true)
    enable_propagate_additional_user_context_data = optional(bool, false)
    access_token_validity                         = optional(number, 60)
    id_token_validity                             = optional(number, 60)
    refresh_token_validity                        = optional(number, 5)
    token_validity_units = optional(object({
      access_token  = optional(string, "minutes")
      id_token      = optional(string, "minutes")
      refresh_token = optional(string, "days")
    }))
  }))
  default = []
}

variable "user_pool_domain" {
  description = "ユーザープールドメイン設定"
  type = object({
    domain          = string
    certificate_arn = optional(string)
  })
  default = null
}

variable "identity_providers" {
  description = "アイデンティティプロバイダー設定"
  type = list(object({
    provider_name     = string
    provider_type     = string
    provider_details  = map(string)
    attribute_mapping = optional(map(string))
  }))
  default = []
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
