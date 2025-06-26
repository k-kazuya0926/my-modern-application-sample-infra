output "function_name" {
  description = "Lambda関数の名前"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Lambda関数のARN"
  value       = aws_lambda_function.this.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logsグループの名前"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch LogsグループのARN"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}
