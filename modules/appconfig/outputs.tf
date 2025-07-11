# Application outputs
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

# Environment outputs
output "environment_id" {
  description = "AppConfig環境ID"
  value       = aws_appconfig_environment.this.environment_id
}

output "environment_arn" {
  description = "AppConfig環境ARN"
  value       = aws_appconfig_environment.this.arn
}

output "environment_name" {
  description = "AppConfig環境名"
  value       = aws_appconfig_environment.this.name
}

# Configuration Profile outputs
output "configuration_profile_id" {
  description = "Configuration ProfileID"
  value       = aws_appconfig_configuration_profile.this.configuration_profile_id
}

output "configuration_profile_arn" {
  description = "Configuration ProfileARN"
  value       = aws_appconfig_configuration_profile.this.arn
}

output "configuration_profile_name" {
  description = "Configuration Profile名"
  value       = aws_appconfig_configuration_profile.this.name
}

# Deployment Strategy outputs
output "deployment_strategy_id" {
  description = "デプロイメント戦略ID"
  value       = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].id : null
}

output "deployment_strategy_arn" {
  description = "デプロイメント戦略ARN"
  value       = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].arn : null
}

output "deployment_strategy_name" {
  description = "デプロイメント戦略名"
  value       = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].name : null
}

# Hosted Configuration Version outputs
output "hosted_configuration_version_number" {
  description = "ホスト型設定バージョン番号"
  value       = var.create_hosted_configuration ? aws_appconfig_hosted_configuration_version.this[0].version_number : null
}

output "hosted_configuration_arn" {
  description = "ホスト型設定ARN"
  value       = var.create_hosted_configuration ? aws_appconfig_hosted_configuration_version.this[0].arn : null
}

# Deployment outputs
output "deployment_number" {
  description = "デプロイメント番号"
  value       = var.create_deployment ? aws_appconfig_deployment.this[0].deployment_number : null
}

output "deployment_arn" {
  description = "デプロイメントARN"
  value       = var.create_deployment ? aws_appconfig_deployment.this[0].arn : null
}

output "deployment_state" {
  description = "デプロイメント状態"
  value       = var.create_deployment ? aws_appconfig_deployment.this[0].state : null
}
