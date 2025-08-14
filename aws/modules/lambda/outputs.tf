output "function_name" {
  description = "Lambda関数の名前"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Lambda関数のARN"
  value       = aws_lambda_function.this.arn
}

output "iam_role_arn" {
  description = "Lambda実行ロールのARN"
  value       = aws_iam_role.execution_role.arn
}

output "iam_role_name" {
  description = "Lambda実行ロールの名前"
  value       = aws_iam_role.execution_role.name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logsグループの名前"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch LogsグループのARN"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}
