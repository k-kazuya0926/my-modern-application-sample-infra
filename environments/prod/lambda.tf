module "lambda_hello_world" {
  source             = "../../modules/lambda"
  project_name       = var.project_name
  env                = var.env
  function_name      = "hello-world"
  execution_role_arn = module.lambda_execution_role_hello_world.iam_role_arn
  image_uri          = "${module.ecr_hello_world.repository_url}:dummy"
}

module "lambda_tmp" {
  source             = "../../modules/lambda"
  project_name       = var.project_name
  env                = var.env
  function_name      = "tmp"
  execution_role_arn = module.lambda_execution_role_tmp.iam_role_arn
  image_uri          = "${module.ecr_tmp.repository_url}:dummy"
}
