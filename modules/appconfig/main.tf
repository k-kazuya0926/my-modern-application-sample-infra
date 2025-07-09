# AppConfigアプリケーション
resource "aws_appconfig_application" "this" {
  name        = "${var.github_repository_name}-${var.env}-${var.application_name}"
  description = var.application_description

  tags = var.tags
}

# AppConfig環境
resource "aws_appconfig_environment" "this" {
  for_each = var.environments

  name           = each.key
  description    = each.value.description
  application_id = aws_appconfig_application.this.id

  dynamic "monitor" {
    for_each = each.value.monitors != null ? each.value.monitors : []
    content {
      alarm_arn      = monitor.value.alarm_arn
      alarm_role_arn = monitor.value.alarm_role_arn
    }
  }

  tags = var.tags
}

# AppConfig設定プロファイル
resource "aws_appconfig_configuration_profile" "this" {
  for_each = var.configuration_profiles

  application_id = aws_appconfig_application.this.id
  name           = each.key
  description    = each.value.description
  location_uri   = each.value.location_uri
  type           = each.value.type

  dynamic "validator" {
    for_each = each.value.validators != null ? each.value.validators : []
    content {
      content = validator.value.content
      type    = validator.value.type
    }
  }

  tags = var.tags
}

# AppConfigデプロイメント戦略
resource "aws_appconfig_deployment_strategy" "this" {
  for_each = var.deployment_strategies

  name                           = each.key
  description                    = each.value.description
  deployment_duration_in_minutes = each.value.deployment_duration_in_minutes
  final_bake_time_in_minutes     = each.value.final_bake_time_in_minutes
  growth_factor                  = each.value.growth_factor
  growth_type                    = each.value.growth_type
  replicate_to                   = each.value.replicate_to

  tags = var.tags
}

# AppConfig ホストされた設定バージョン
resource "aws_appconfig_hosted_configuration_version" "this" {
  for_each = var.hosted_configurations

  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this[each.value.profile_name].configuration_profile_id
  description              = each.value.description
  content_type             = each.value.content_type
  content                  = each.value.content
}

# AppConfigデプロイメント
resource "aws_appconfig_deployment" "this" {
  for_each = var.deployments

  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this[each.value.profile_name].configuration_profile_id
  configuration_version    = each.value.configuration_version != null ? each.value.configuration_version : aws_appconfig_hosted_configuration_version.this[each.value.hosted_config_name].version_number
  deployment_strategy_id   = each.value.deployment_strategy_id != null ? each.value.deployment_strategy_id : aws_appconfig_deployment_strategy.this[each.value.strategy_name].id
  description              = each.value.description
  environment_id           = aws_appconfig_environment.this[each.value.environment_name].environment_id

  tags = var.tags

  depends_on = [
    aws_appconfig_hosted_configuration_version.this
  ]
}
