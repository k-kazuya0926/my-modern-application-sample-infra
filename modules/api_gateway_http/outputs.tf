output "api_id" {
  description = "API Gateway のID"
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "API Gateway のエンドポイント"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "execution_arn" {
  description = "API Gateway の実行ARN"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_invoke_url" {
  description = "API Gateway ステージの呼び出しURL"
  value       = aws_apigatewayv2_stage.this.invoke_url
}

output "authorizer_id" {
  description = "Cognito認証のオーソライザーID"
  value       = var.cognito_user_pool_id != null ? aws_apigatewayv2_authorizer.cognito_authorizer[0].id : null
}
