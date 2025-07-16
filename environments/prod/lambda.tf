module "lambda_hello_world" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "hello-world"
  iam_policy             = data.aws_iam_policy_document.lambda_hello_world.json
  image_uri              = "${module.ecr_hello_world.repository_url}:dummy"
}

module "lambda_tmp" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "tmp"
  iam_policy             = data.aws_iam_policy_document.lambda_tmp.json
  image_uri              = "${module.ecr_tmp.repository_url}:dummy"
}

module "lambda_read_and_write_s3" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "read-and-write-s3"
  iam_policy             = data.aws_iam_policy_document.lambda_read_and_write_s3.json
  image_uri              = "${module.ecr_read_and_write_s3.repository_url}:dummy"
  environment_variables = {
    OUTPUT_BUCKET = module.s3_write.bucket_name
  }

  s3_trigger_bucket_name = module.s3_read.bucket_name
  s3_trigger_bucket_arn  = module.s3_read.bucket_arn
}

module "lambda_register_user" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "register-user"
  iam_policy             = data.aws_iam_policy_document.lambda_register_user.json
  image_uri              = "${module.ecr_register_user.repository_url}:dummy"
  environment_variables = {
    ENV             = local.env
    CONTENTS_BUCKET = module.s3_contents.bucket_name
    FILE_NAME       = "special.txt"
    MAIL_FROM       = var.mail_from
  }
}

module "lambda_send_message" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "send-message"
  iam_policy             = data.aws_iam_policy_document.lambda_send_message.json
  image_uri              = "${module.ecr_send_message.repository_url}:dummy"
  environment_variables = {
    ENV = local.env
  }
  s3_trigger_bucket_name = module.s3_mail_body.bucket_name
  s3_trigger_bucket_arn  = module.s3_mail_body.bucket_arn
  enable_tracing         = true
}

module "lambda_read_message_and_send_mail" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "read-message-and-send-mail"
  iam_policy             = data.aws_iam_policy_document.lambda_read_message_and_send_mail.json
  image_uri              = "${module.ecr_read_message_and_send_mail.repository_url}:dummy"
  environment_variables = {
    ENV       = local.env
    MAIL_FROM = var.mail_from
  }
  sqs_trigger_queue_arn = module.sqs_send_mail.queue_arn
  enable_tracing        = true
}

module "lambda_receive_bounce_mail" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "receive-bounce-mail"
  iam_policy             = data.aws_iam_policy_document.lambda_receive_bounce_mail.json
  image_uri              = "${module.ecr_receive_bounce_mail.repository_url}:dummy"
  environment_variables = {
    ENV        = local.env
    MAIL_TABLE = data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_name
  }
  enable_tracing = true
}

module "lambda_feature_flags" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "feature-flags"
  iam_policy             = data.aws_iam_policy_document.lambda_feature_flags.json
  image_uri              = "${module.ecr_feature_flags.repository_url}:dummy"
  environment_variables = {
    APPCONFIG_APPLICATION_ID           = module.appconfig_feature_flags.application_id
    APPCONFIG_ENVIRONMENT_ID           = module.appconfig_feature_flags.environment_id
    APPCONFIG_CONFIGURATION_PROFILE_ID = module.appconfig_feature_flags.configuration_profile_id
  }
}

module "lambda_auth_by_cognito" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "auth-by-cognito"
  iam_policy             = data.aws_iam_policy_document.lambda_auth_by_cognito.json
  image_uri              = "${module.ecr_auth_by_cognito.repository_url}:dummy"
}

module "lambda_process_payment" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "process-payment"
  iam_policy             = data.aws_iam_policy_document.lambda_process_payment.json
  image_uri              = "${module.ecr_process_payment.repository_url}:dummy"
}

module "lambda_cancel_payment" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "cancel-payment"
  iam_policy             = data.aws_iam_policy_document.lambda_cancel_payment.json
  image_uri              = "${module.ecr_cancel_payment.repository_url}:dummy"
}

module "lambda_create_purchase_history" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "create-purchase-history"
  iam_policy             = data.aws_iam_policy_document.lambda_create_purchase_history.json
  image_uri              = "${module.ecr_create_purchase_history.repository_url}:dummy"
}

module "lambda_delete_purchase_history" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "delete-purchase-history"
  iam_policy             = data.aws_iam_policy_document.lambda_delete_purchase_history.json
  image_uri              = "${module.ecr_delete_purchase_history.repository_url}:dummy"
}

module "lambda_award_points" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "award-points"
  iam_policy             = data.aws_iam_policy_document.lambda_award_points.json
  image_uri              = "${module.ecr_award_points.repository_url}:dummy"
}
