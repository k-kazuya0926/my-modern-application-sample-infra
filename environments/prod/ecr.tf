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

module "ecr_read_and_write_s3" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "read-and-write-s3"
}

module "ecr_register_user" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "register-user"
}

module "ecr_send_message" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "send-message"
}
