resource "aws_sfn_state_machine" "this" {
  name     = "${var.github_repository_name}-${var.env}-${var.state_machine_name}"
  role_arn = aws_iam_role.step_functions_execution_role.arn

  definition = var.definition

  type = var.type

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.step_functions_logs.arn}:*"
    include_execution_data = var.include_execution_data
    level                  = var.log_level
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "step_functions_logs" {
  name              = "/aws/stepfunctions/${var.github_repository_name}-${var.env}-${var.state_machine_name}"
  retention_in_days = var.log_retention_in_days
}

# Step Functions実行ロール
resource "aws_iam_role" "step_functions_execution_role" {
  name               = "${var.github_repository_name}-${var.env}-${var.state_machine_name}"
  assume_role_policy = data.aws_iam_policy_document.step_functions_assume_role.json
}

data "aws_iam_policy_document" "step_functions_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

# Step Functions基本実行ポリシー
resource "aws_iam_policy" "step_functions_execution_policy" {
  name   = "${var.github_repository_name}-${var.env}-${var.state_machine_name}"
  policy = data.aws_iam_policy_document.step_functions_execution_policy.json
}

data "aws_iam_policy_document" "step_functions_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }

  # カスタムポリシーがある場合は追加
  dynamic "statement" {
    for_each = var.custom_policy_statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role_policy_attachment" "step_functions_execution_policy" {
  role       = aws_iam_role.step_functions_execution_role.name
  policy_arn = aws_iam_policy.step_functions_execution_policy.arn
}

# X-Rayトレーシング用のポリシーアタッチメント（オプション）
resource "aws_iam_role_policy_attachment" "xray_write_only_access" {
  count      = var.enable_xray_tracing ? 1 : 0
  role       = aws_iam_role.step_functions_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
