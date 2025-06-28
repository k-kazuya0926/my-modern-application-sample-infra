module "lambda_execution_role_hello_world" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = var.env
  role_name              = "hello-world"
}

module "lambda_execution_role_tmp" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = var.env
  role_name              = "tmp"
}

module "github_actions_openid_connect_provider" {
  source = "../../modules/github_actions_openid_connect_provider"
}

module "github_actions_role" {
  source                          = "../../modules/github_actions_role"
  iam_openid_connect_provider_arn = module.github_actions_openid_connect_provider.iam_openid_connect_provider_arn
  github_owner_name               = var.github_owner_name
  github_repository_name          = var.github_repository_name
  env                             = var.env
}
