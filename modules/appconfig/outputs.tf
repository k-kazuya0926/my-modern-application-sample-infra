output "application_id" {
  description = "AppConfigアプリケーションID"
  value       = aws_appconfig_application.this.id
}

output "application_arn" {
  description = "AppConfigアプリケーションARN"
  value       = aws_appconfig_application.this.arn
}

output "application_name" {
  description = "AppConfigアプリケーション名"
  value       = aws_appconfig_application.this.name
}

output "environment_ids" {
  description = "AppConfig環境IDのマップ"
  value       = { for k, v in aws_appconfig_environment.this : k => v.environment_id }
}

output "environment_arns" {
  description = "AppConfig環境ARNのマップ"
  value       = { for k, v in aws_appconfig_environment.this : k => v.arn }
}

output "configuration_profile_ids" {
  description = "AppConfig設定プロファイルIDのマップ"
  value       = { for k, v in aws_appconfig_configuration_profile.this : k => v.configuration_profile_id }
}

output "configuration_profile_arns" {
  description = "AppConfig設定プロファイルARNのマップ"
  value       = { for k, v in aws_appconfig_configuration_profile.this : k => v.arn }
}

output "deployment_strategy_ids" {
  description = "AppConfigデプロイメント戦略IDのマップ"
  value       = { for k, v in aws_appconfig_deployment_strategy.this : k => v.id }
}

output "deployment_strategy_arns" {
  description = "AppConfigデプロイメント戦略ARNのマップ"
  value       = { for k, v in aws_appconfig_deployment_strategy.this : k => v.arn }
}

output "hosted_configuration_versions" {
  description = "AppConfigホストされた設定バージョンのマップ"
  value       = { for k, v in aws_appconfig_hosted_configuration_version.this : k => v.version_number }
}

output "deployment_numbers" {
  description = "AppConfigデプロイメント番号のマップ"
  value       = { for k, v in aws_appconfig_deployment.this : k => v.deployment_number }
}
