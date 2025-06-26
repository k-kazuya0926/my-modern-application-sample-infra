module "ecr_hello_world" {
  source = "../../modules/ecr"

  project_name    = var.project_name
  env             = var.env
  repository_name = "hello-world"
}

module "ecr_tmp" {
  source = "../../modules/ecr"

  project_name    = var.project_name
  env             = var.env
  repository_name = "tmp"
}
