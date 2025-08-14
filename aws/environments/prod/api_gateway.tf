module "api_gateway_http_register_user" {
  source                 = "../../modules/api_gateway_http"
  github_repository_name = var.github_repository_name
  env                    = local.env
  api_name               = "register-user"
  description            = "User registration API"

  routes = [
    {
      route_key = "POST /users"
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

module "api_gateway_http_auth_by_cognito" {
  source                 = "../../modules/api_gateway_http"
  github_repository_name = var.github_repository_name
  env                    = local.env
  api_name               = "auth-by-cognito"
  description            = "Cognito protected endpoints"

  # Cognito認証設定
  cognito_user_pool_id        = module.cognito_user_pool_spa.user_pool_id
  cognito_user_pool_client_id = module.cognito_user_pool_spa.user_pool_client_ids[0] # SPA用クライアント

  integrations = [
    {
      integration_uri    = module.lambda_auth_by_cognito.function_arn
      integration_type   = "AWS_PROXY"
      integration_method = "POST"
    }
  ]

  # 認証が必要なルート
  routes_with_auth = [
    {
      route_key = "POST /auth-by-cognito"
      auth_type = "JWT"
    }
  ]

  lambda_permissions = [
    {
      function_name = module.lambda_auth_by_cognito.function_name
    }
  ]

  # CORS設定をSPAに適合させる
  cors_configuration = {
    allow_credentials = true
    allow_headers     = ["origin", "content-type", "accept", "authorization", "x-requested-with"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins     = ["http://localhost:3000", "https://localhost:3000"] # 開発環境用
    expose_headers    = []
    max_age           = 86400
  }
}
