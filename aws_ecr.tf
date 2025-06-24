module "ecr_hello_world" {
  source = "./modules/ecr"

  repository_name = "${local.project_name}-hello-world"
}

module "ecr_tmp" {
  source = "./modules/ecr"

  repository_name = "${local.project_name}-tmp"
}
