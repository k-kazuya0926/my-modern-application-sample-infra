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

# API Gateway 出力値
output "api_gateway_endpoint" {
  description = "API Gateway Endpoint URL"
  value       = module.api_gateway_register_user.stage_invoke_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = module.api_gateway_register_user.api_id
}
