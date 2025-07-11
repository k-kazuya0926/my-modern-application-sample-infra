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
      module.ecr_feature_flags.repository_arn
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
      "${module.lambda_feature_flags.function_arn}:*"
    ]
  }
}


module "lambda_execution_role_hello_world" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "hello-world"
  policy                 = data.aws_iam_policy_document.lambda_hello_world.json
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


module "lambda_execution_role_tmp" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "tmp"
  policy                 = data.aws_iam_policy_document.lambda_tmp.json
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


module "lambda_execution_role_read_and_write_s3" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "read-and-write-s3"
  policy                 = data.aws_iam_policy_document.lambda_read_and_write_s3.json
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


module "lambda_execution_role_register_user" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "register-user"
  policy                 = data.aws_iam_policy_document.lambda_register_user.json
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


module "lambda_execution_role_send_message" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "send-message"
  policy                 = data.aws_iam_policy_document.lambda_send_message.json
  enable_xray            = true
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


module "lambda_execution_role_read_message_and_send_mail" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "read-message-and-send-mail"
  policy                 = data.aws_iam_policy_document.lambda_read_message_and_send_mail.json
  enable_xray            = true
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


module "lambda_execution_role_receive_bounce_mail" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "receive-bounce-mail"
  policy                 = data.aws_iam_policy_document.lambda_receive_bounce_mail.json
  enable_xray            = true
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


module "lambda_execution_role_feature_flags" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "feature-flags"
  policy                 = data.aws_iam_policy_document.lambda_feature_flags.json
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
}
