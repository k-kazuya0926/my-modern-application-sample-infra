output "user_pool_id" {
  description = "CognitoユーザープールのID"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "CognitoユーザープールのARN"
  value       = aws_cognito_user_pool.this.arn
}

output "user_pool_name" {
  description = "Cognitoユーザープールの名前"
  value       = aws_cognito_user_pool.this.name
}

output "user_pool_endpoint" {
  description = "Cognitoユーザープールのエンドポイント"
  value       = aws_cognito_user_pool.this.endpoint
}

output "user_pool_creation_date" {
  description = "Cognitoユーザープールの作成日"
  value       = aws_cognito_user_pool.this.creation_date
}

output "user_pool_last_modified_date" {
  description = "Cognitoユーザープールの最終更新日"
  value       = aws_cognito_user_pool.this.last_modified_date
}

output "user_pool_client_ids" {
  description = "ユーザープールクライアントのIDリスト"
  value       = aws_cognito_user_pool_client.this[*].id
}

output "user_pool_client_secrets" {
  description = "ユーザープールクライアントのシークレットリスト（機密情報）"
  value       = aws_cognito_user_pool_client.this[*].client_secret
  sensitive   = true
}

output "user_pool_domain" {
  description = "ユーザープールドメイン"
  value       = var.user_pool_domain != null ? aws_cognito_user_pool_domain.this[0].domain : null
}

output "user_pool_domain_cloudfront_distribution_arn" {
  description = "ユーザープールドメインのCloudFront配信ARN"
  value       = var.user_pool_domain != null ? aws_cognito_user_pool_domain.this[0].cloudfront_distribution_arn : null
}

output "identity_provider_names" {
  description = "アイデンティティプロバイダー名のリスト"
  value       = aws_cognito_identity_provider.this[*].provider_name
}

output "user_pool_clients" {
  description = "ユーザープールクライアントの詳細情報"
  value = {
    for i, client in aws_cognito_user_pool_client.this : client.name => {
      id                           = client.id
      name                         = client.name
      user_pool_id                 = client.user_pool_id
      generate_secret              = client.generate_secret
      allowed_oauth_flows          = client.allowed_oauth_flows
      allowed_oauth_scopes         = client.allowed_oauth_scopes
      callback_urls                = client.callback_urls
      logout_urls                  = client.logout_urls
      supported_identity_providers = client.supported_identity_providers
    }
  }
}
