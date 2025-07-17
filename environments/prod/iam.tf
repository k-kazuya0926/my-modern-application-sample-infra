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
      module.ecr_award_points.repository_arn,
      module.ecr_fan_out_consumer_1.repository_arn,
      module.ecr_fan_out_consumer_2.repository_arn,
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
      "${module.lambda_award_points.function_arn}:*",
      module.lambda_fan_out_consumer_1.function_arn,
      "${module.lambda_fan_out_consumer_1.function_arn}:*",
      module.lambda_fan_out_consumer_2.function_arn,
      "${module.lambda_fan_out_consumer_2.function_arn}:*"
    ]
  }
}
