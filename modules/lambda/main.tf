resource "aws_lambda_function" "this" {
  function_name = "${var.github_repository_name}-${var.env}-${var.function_name}"
  role          = var.execution_role_arn
  package_type  = "Image"
  image_uri     = var.image_uri

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }

  memory_size = var.memory_size
  timeout     = var.timeout

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.github_repository_name}-${var.env}-${var.function_name}"
  retention_in_days = var.log_retention_days
}
