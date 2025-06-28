module "ecr_hello_world" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "hello-world"
}

module "ecr_tmp" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "tmp"
}
