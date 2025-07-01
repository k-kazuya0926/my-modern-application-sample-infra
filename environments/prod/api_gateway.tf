module "api_gateway_register_user" {
  source                 = "../../modules/api_gateway_http"
  github_repository_name = var.github_repository_name
  env                    = local.env
  api_name               = "register-user"
  description            = "User registration API"

  routes = [
    {
      route_key = "POST /register"
    }
  ]

  integrations = [
    {
      integration_uri    = module.lambda_register_user.function_arn
      integration_type   = "AWS_PROXY"
      integration_method = "POST"
    }
  ]

  lambda_permissions = [
    {
      function_name = module.lambda_register_user.function_name
    }
  ]
}
