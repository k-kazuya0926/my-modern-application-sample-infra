resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-${var.env}-${var.function_name}"
  role          = var.execution_role_arn
  package_type  = "Image"
  image_uri     = var.image_uri

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }

  # メモリとタイムアウトの設定
  memory_size = var.memory_size
  timeout     = var.timeout

  # ログ保持期間
  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

# CloudWatch Logs グループ
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.env}-${var.function_name}"
  retention_in_days = var.log_retention_days
}
