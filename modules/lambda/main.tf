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

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = var.enable_tracing ? "Active" : "PassThrough"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.github_repository_name}-${var.env}-${var.function_name}"
  retention_in_days = var.log_retention_days
}

# S3トリガーのためのLambda許可
resource "aws_lambda_permission" "s3_trigger" {
  count         = var.s3_trigger_bucket_name != null ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_trigger_bucket_arn
}

# S3バケット通知設定
resource "aws_s3_bucket_notification" "s3_trigger" {
  count  = var.s3_trigger_bucket_name != null ? 1 : 0
  bucket = var.s3_trigger_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = var.s3_trigger_events
  }

  depends_on = [aws_lambda_permission.s3_trigger]
}

# SQSトリガーのためのイベントソースマッピング
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  count            = var.sqs_trigger_queue_arn != null ? 1 : 0
  event_source_arn = var.sqs_trigger_queue_arn
  function_name    = aws_lambda_function.this.arn
  batch_size       = var.sqs_trigger_batch_size
}
