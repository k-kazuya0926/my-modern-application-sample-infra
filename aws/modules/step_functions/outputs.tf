output "state_machine_arn" {
  description = "Step FunctionsステートマシンのARN"
  value       = aws_sfn_state_machine.this.arn
}

output "state_machine_name" {
  description = "Step Functionsステートマシンの名前"
  value       = aws_sfn_state_machine.this.name
}

output "execution_role_arn" {
  description = "Step Functions実行ロールのARN"
  value       = aws_iam_role.step_functions_execution_role.arn
}

output "execution_role_name" {
  description = "Step Functions実行ロールの名前"
  value       = aws_iam_role.step_functions_execution_role.name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logsグループの名前"
  value       = aws_cloudwatch_log_group.step_functions_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch LogsグループのARN"
  value       = aws_cloudwatch_log_group.step_functions_logs.arn
}
