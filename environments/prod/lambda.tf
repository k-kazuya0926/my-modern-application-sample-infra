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

  s3_trigger_bucket_name = module.s3_mail_body.bucket_name
  s3_trigger_bucket_arn  = module.s3_mail_body.bucket_arn
}
