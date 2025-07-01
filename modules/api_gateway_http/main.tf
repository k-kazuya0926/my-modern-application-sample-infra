resource "aws_apigatewayv2_api" "this" {
  name          = "${var.github_repository_name}-${var.env}-${var.api_name}"
  description   = var.description
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = var.cors_configuration.allow_credentials
    allow_headers     = var.cors_configuration.allow_headers
    allow_methods     = var.cors_configuration.allow_methods
    allow_origins     = var.cors_configuration.allow_origins
    expose_headers    = var.cors_configuration.expose_headers
    max_age           = var.cors_configuration.max_age
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.github_repository_name}-${var.env}-${var.api_name}"
  retention_in_days = var.log_retention_days
}

# Lambda統合のためのルート
resource "aws_apigatewayv2_route" "this" {
  count  = length(var.routes)
  api_id = aws_apigatewayv2_api.this.id

  route_key = var.routes[count.index].route_key
  target    = "integrations/${aws_apigatewayv2_integration.this[count.index].id}"
}

# Lambda統合
resource "aws_apigatewayv2_integration" "this" {
  count  = length(var.integrations)
  api_id = aws_apigatewayv2_api.this.id

  integration_uri        = var.integrations[count.index].integration_uri
  integration_type       = var.integrations[count.index].integration_type
  integration_method     = var.integrations[count.index].integration_method
  payload_format_version = "2.0"
}

# Lambda統合のための許可
resource "aws_lambda_permission" "api_gateway" {
  count         = length(var.lambda_permissions)
  statement_id  = "AllowExecutionFromAPIGateway-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_permissions[count.index].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
