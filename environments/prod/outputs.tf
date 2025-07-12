# Cognito User Pool 出力値
output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito_user_pool.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = module.cognito_user_pool.user_pool_arn
}

output "cognito_user_pool_name" {
  description = "Cognito User Pool Name"
  value       = module.cognito_user_pool.user_pool_name
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.cognito_user_pool.user_pool_client_ids[0]
}

output "cognito_user_pool_endpoint" {
  description = "Cognito User Pool Endpoint"
  value       = module.cognito_user_pool.user_pool_endpoint
}

# Cognito Hosted UI 出力値
output "cognito_hosted_ui_url" {
  description = "Cognito Hosted UI Base URL"
  value       = module.cognito_user_pool.hosted_ui_url
}

output "cognito_user_pool_domain" {
  description = "Cognito User Pool Domain"
  value       = module.cognito_user_pool.user_pool_domain
}

output "cognito_login_urls" {
  description = "Cognito Login URLs for each client"
  value       = module.cognito_user_pool.login_urls
}

output "cognito_user_pool_clients" {
  description = "Cognito User Pool Clients information"
  value       = module.cognito_user_pool.user_pool_clients
}

# API Gateway 出力値
output "api_gateway_endpoint" {
  description = "API Gateway Endpoint URL"
  value       = module.api_gateway_register_user.stage_invoke_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = module.api_gateway_register_user.api_id
}
