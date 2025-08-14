# AppConfig Application
resource "aws_appconfig_application" "this" {
  name        = "${var.github_repository_name}-${var.env}-${var.application_name}"
  description = var.application_description

  tags = var.tags
}

# AppConfig Environment
resource "aws_appconfig_environment" "this" {
  name           = var.env
  description    = var.environment_description
  application_id = aws_appconfig_application.this.id

  dynamic "monitor" {
    for_each = var.monitors
    content {
      alarm_arn      = monitor.value.alarm_arn
      alarm_role_arn = monitor.value.alarm_role_arn
    }
  }

  tags = var.tags
}

# AppConfig Configuration Profile
resource "aws_appconfig_configuration_profile" "this" {
  application_id = aws_appconfig_application.this.id
  name           = var.configuration_profile_name
  description    = var.configuration_profile_description
  location_uri   = var.location_uri
  type           = var.configuration_profile_type

  dynamic "validator" {
    for_each = var.validators
    content {
      content = validator.value.content
      type    = validator.value.type
    }
  }

  tags = var.tags
}

# AppConfig Deployment Strategy
resource "aws_appconfig_deployment_strategy" "this" {
  count = var.create_deployment_strategy ? 1 : 0

  name                           = "${var.github_repository_name}-${var.env}-${var.deployment_strategy_name}"
  description                    = var.deployment_strategy_description
  deployment_duration_in_minutes = var.deployment_duration_in_minutes
  final_bake_time_in_minutes     = var.final_bake_time_in_minutes
  growth_factor                  = var.growth_factor
  growth_type                    = var.growth_type
  replicate_to                   = var.replicate_to

  tags = var.tags
}

# AppConfig Hosted Configuration Version (for hosted configurations)
resource "aws_appconfig_hosted_configuration_version" "this" {
  count = var.create_hosted_configuration ? 1 : 0

  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this.configuration_profile_id
  content_type             = var.hosted_configuration_content_type
  content                  = var.hosted_configuration_content
  description              = var.hosted_configuration_description

  lifecycle {
    ignore_changes = [content]
  }
}

# AppConfig Deployment
resource "aws_appconfig_deployment" "this" {
  count = var.create_deployment ? 1 : 0

  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this.configuration_profile_id
  configuration_version    = var.create_hosted_configuration ? aws_appconfig_hosted_configuration_version.this[0].version_number : var.configuration_version
  deployment_strategy_id   = var.create_deployment_strategy ? aws_appconfig_deployment_strategy.this[0].id : var.deployment_strategy_id
  environment_id           = aws_appconfig_environment.this.environment_id
  description              = var.deployment_description

  tags = var.tags
}
