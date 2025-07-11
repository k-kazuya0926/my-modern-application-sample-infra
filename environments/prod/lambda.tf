module "lambda_hello_world" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "hello-world"
  execution_role_arn     = module.lambda_execution_role_hello_world.iam_role_arn
  image_uri              = "${module.ecr_hello_world.repository_url}:dummy"
}

module "lambda_tmp" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "tmp"
  execution_role_arn     = module.lambda_execution_role_tmp.iam_role_arn
  image_uri              = "${module.ecr_tmp.repository_url}:dummy"
}

module "lambda_read_and_write_s3" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "read-and-write-s3"
  execution_role_arn     = module.lambda_execution_role_read_and_write_s3.iam_role_arn
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
  execution_role_arn     = module.lambda_execution_role_register_user.iam_role_arn
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
  execution_role_arn     = module.lambda_execution_role_send_message.iam_role_arn
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
  execution_role_arn     = module.lambda_execution_role_read_message_and_send_mail.iam_role_arn
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
  execution_role_arn     = module.lambda_execution_role_receive_bounce_mail.iam_role_arn
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
  execution_role_arn     = module.lambda_execution_role_feature_flags.iam_role_arn
  image_uri              = "${module.ecr_feature_flags.repository_url}:dummy"
}
