module "ecr_hello_world" {
  source = "../modules/ecr"

  project_name    = local.project_name
  env             = local.env
  repository_name = "hello-world"
}

module "ecr_tmp" {
  source = "../modules/ecr"

  project_name    = local.project_name
  env             = local.env
  repository_name = "tmp"
}
