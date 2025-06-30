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

  # S3トリガー設定
  s3_trigger_bucket_name = module.s3_read.bucket_name
  s3_trigger_bucket_arn  = module.s3_read.bucket_arn
}
