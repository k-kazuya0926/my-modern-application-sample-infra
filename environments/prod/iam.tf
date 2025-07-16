module "github_actions_openid_connect_provider" {
  source = "../../modules/github_actions_openid_connect_provider"
}

module "github_actions_role" {
  source                          = "../../modules/github_actions_role"
  iam_openid_connect_provider_arn = module.github_actions_openid_connect_provider.iam_openid_connect_provider_arn
  github_owner_name               = var.github_owner_name
  github_repository_name          = var.github_repository_name
  env                             = local.env
  policy                          = data.aws_iam_policy_document.github_actions.json
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid    = "ECRPermissions"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECRRepositoryPermissions"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      module.ecr_hello_world.repository_arn,
      module.ecr_tmp.repository_arn,
      module.ecr_read_and_write_s3.repository_arn,
      module.ecr_register_user.repository_arn,
      module.ecr_send_message.repository_arn,
      module.ecr_read_message_and_send_mail.repository_arn,
      module.ecr_receive_bounce_mail.repository_arn,
      module.ecr_feature_flags.repository_arn,
      module.ecr_auth_by_cognito.repository_arn,
      module.ecr_process_payment.repository_arn,
      module.ecr_cancel_payment.repository_arn,
      module.ecr_create_purchase_history.repository_arn,
      module.ecr_delete_purchase_history.repository_arn,
      module.ecr_award_points.repository_arn
    ]
  }

  statement {
    sid    = "LambdaDeployPermissions"
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:PublishVersion",
      "lambda:UpdateAlias"
    ]
    resources = [
      module.lambda_hello_world.function_arn,
      "${module.lambda_hello_world.function_arn}:*",
      module.lambda_tmp.function_arn,
      "${module.lambda_tmp.function_arn}:*",
      module.lambda_read_and_write_s3.function_arn,
      "${module.lambda_read_and_write_s3.function_arn}:*",
      module.lambda_register_user.function_arn,
      "${module.lambda_register_user.function_arn}:*",
      module.lambda_send_message.function_arn,
      "${module.lambda_send_message.function_arn}:*",
      module.lambda_read_message_and_send_mail.function_arn,
      "${module.lambda_read_message_and_send_mail.function_arn}:*",
      module.lambda_receive_bounce_mail.function_arn,
      "${module.lambda_receive_bounce_mail.function_arn}:*",
      module.lambda_feature_flags.function_arn,
      "${module.lambda_feature_flags.function_arn}:*",
      module.lambda_auth_by_cognito.function_arn,
      "${module.lambda_auth_by_cognito.function_arn}:*",
      module.lambda_process_payment.function_arn,
      "${module.lambda_process_payment.function_arn}:*",
      module.lambda_cancel_payment.function_arn,
      "${module.lambda_cancel_payment.function_arn}:*",
      module.lambda_create_purchase_history.function_arn,
      "${module.lambda_create_purchase_history.function_arn}:*",
      module.lambda_delete_purchase_history.function_arn,
      "${module.lambda_delete_purchase_history.function_arn}:*",
      module.lambda_award_points.function_arn,
      "${module.lambda_award_points.function_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_hello_world" {
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
    resources = ["${module.lambda_hello_world.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_tmp" {
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
    resources = ["${module.lambda_tmp.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_read_and_write_s3" {
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
    resources = ["${module.lambda_read_and_write_s3.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      module.s3_read.bucket_arn,
      "${module.s3_read.bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${module.s3_write.bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_register_user" {
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
    resources = ["${module.lambda_register_user.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      data.terraform_remote_state.dynamodb.outputs.users_table_arn,
      data.terraform_remote_state.dynamodb.outputs.sequences_table_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      module.s3_contents.bucket_arn,
      "${module.s3_contents.bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = [
      "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_send_message" {
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
    resources = ["${module.lambda_send_message.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:Query"
    ]
    resources = [
      "${data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn}/index/has_error-index"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:UpdateItem"
    ]
    resources = [
      data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl"
    ]
    resources = [
      module.sqs_send_mail.queue_arn
    ]
  }
}

data "aws_iam_policy_document" "lambda_read_message_and_send_mail" {
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
    resources = ["${module.lambda_read_message_and_send_mail.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      module.sqs_send_mail.queue_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${module.s3_mail_body.bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:UpdateItem"
    ]
    resources = [
      data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = [
      "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_receive_bounce_mail" {
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
    resources = ["${module.lambda_receive_bounce_mail.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:UpdateItem"
    ]
    resources = [
      data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
    ]
  }
}

data "aws_iam_policy_document" "lambda_feature_flags" {
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
    resources = ["${module.lambda_feature_flags.cloudwatch_log_group_arn}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "appconfig:StartConfigurationSession",
      "appconfig:GetLatestConfiguration"
    ]
    resources = [
      "arn:aws:appconfig:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:application/${module.appconfig_feature_flags.application_id}/environment/${module.appconfig_feature_flags.environment_id}/configuration/${module.appconfig_feature_flags.configuration_profile_id}"
    ]
  }
}

data "aws_iam_policy_document" "lambda_auth_by_cognito" {
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
    resources = ["${module.lambda_auth_by_cognito.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_process_payment" {
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
    resources = ["${module.lambda_process_payment.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_cancel_payment" {
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
    resources = ["${module.lambda_cancel_payment.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_create_purchase_history" {
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
    resources = ["${module.lambda_create_purchase_history.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_delete_purchase_history" {
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
    resources = ["${module.lambda_delete_purchase_history.cloudwatch_log_group_arn}:*"]
  }
}

data "aws_iam_policy_document" "lambda_award_points" {
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
    resources = ["${module.lambda_award_points.cloudwatch_log_group_arn}:*"]
  }
}
