data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM実行ロール
resource "aws_iam_role" "execution_role" {
  name               = "${var.github_repository_name}-${var.env}-${var.function_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAMポリシードキュメント
data "aws_iam_policy_document" "execution_policy" {
  # 基本的なCloudWatch Logsの権限
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.lambda_logs.arn}:*"]
  }

  # 追加のポリシーステートメント
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "execution_policy" {
  name   = "${var.github_repository_name}-${var.env}-${var.function_name}"
  policy = data.aws_iam_policy_document.execution_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
}

# X-Rayトレーシング用のポリシーアタッチメント
resource "aws_iam_role_policy_attachment" "xray_write_only" {
  count      = var.enable_tracing ? 1 : 0
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

# VPC Lambda用のENI管理権限
resource "aws_iam_role_policy_attachment" "vpc_access_execution" {
  count      = var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name = "${var.github_repository_name}-${var.env}-${var.function_name}"
  role          = aws_iam_role.execution_role.arn
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

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
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
