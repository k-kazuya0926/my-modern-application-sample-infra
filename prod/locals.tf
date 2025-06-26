module "common" {
  source = "../modules/common"
}

locals {
  github_owner_name = module.common.github_owner_name
  project_name      = module.common.project_name
  env               = "prod"
}
