output "api_id" {
  description = "API Gateway HTTP API の ID"
  value       = aws_apigatewayv2_api.this.id
}

output "api_name" {
  description = "API Gateway HTTP API の名前"
  value       = aws_apigatewayv2_api.this.name
}

output "api_arn" {
  description = "API Gateway HTTP API の ARN"
  value       = aws_apigatewayv2_api.this.arn
}

output "execution_arn" {
  description = "API Gateway の実行 ARN"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "api_endpoint" {
  description = "API Gateway の API エンドポイント"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "stage_name" {
  description = "API Gateway ステージ名"
  value       = aws_apigatewayv2_stage.this.name
}

output "stage_arn" {
  description = "API Gateway ステージ ARN"
  value       = aws_apigatewayv2_stage.this.arn
}

output "invoke_url" {
  description = "API Gateway の呼び出し URL"
  value       = aws_apigatewayv2_stage.this.invoke_url
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logs グループの名前"
  value       = aws_cloudwatch_log_group.api_gateway_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch Logs グループの ARN"
  value       = aws_cloudwatch_log_group.api_gateway_logs.arn
}
