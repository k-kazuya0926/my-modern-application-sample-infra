output "service_id" {
  description = "ECSサービスのID"
  value       = aws_ecs_service.main.id
}

output "service_name" {
  description = "ECSサービス名"
  value       = aws_ecs_service.main.name
}

output "service_arn" {
  description = "ECSサービスのARN"
  value       = aws_ecs_service.main.arn
}

output "task_definition_arn" {
  description = "ECSタスク定義のARN"
  value       = aws_ecs_task_definition.main.arn
}

output "task_definition_family" {
  description = "ECSタスク定義のファミリー名"
  value       = aws_ecs_task_definition.main.family
}

output "task_definition_revision" {
  description = "ECSタスク定義のリビジョン番号"
  value       = aws_ecs_task_definition.main.revision
}

output "execution_role_arn" {
  description = "ECSタスク実行ロールのARN"
  value       = aws_iam_role.execution_role.arn
}

output "execution_role_name" {
  description = "ECSタスク実行ロール名"
  value       = aws_iam_role.execution_role.name
}

output "task_role_arn" {
  description = "ECSタスクロールのARN"
  value       = aws_iam_role.task_role.arn
}

output "task_role_name" {
  description = "ECSタスクロール名"
  value       = aws_iam_role.task_role.name
}

output "security_group_id" {
  description = "ECSタスク用セキュリティグループのID"
  value       = aws_security_group.ecs_tasks.id
}

output "security_group_arn" {
  description = "ECSタスク用セキュリティグループのARN"
  value       = aws_security_group.ecs_tasks.arn
}

output "log_group_name" {
  description = "CloudWatch LogsグループのID"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "log_group_arn" {
  description = "CloudWatch LogsグループのARN"
  value       = aws_cloudwatch_log_group.ecs_logs.arn
}

output "autoscaling_target_resource_id" {
  description = "オートスケーリングターゲットのリソースID"
  value       = var.enable_autoscaling ? aws_appautoscaling_target.ecs_target[0].resource_id : null
}

output "autoscaling_policy_cpu_arn" {
  description = "CPUベースのオートスケーリングポリシーのARN"
  value       = var.enable_autoscaling ? aws_appautoscaling_policy.ecs_policy_cpu[0].arn : null
}

output "autoscaling_policy_memory_arn" {
  description = "メモリベースのオートスケーリングポリシーのARN"
  value       = var.enable_autoscaling ? aws_appautoscaling_policy.ecs_policy_memory[0].arn : null
}