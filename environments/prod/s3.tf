module "s3_read" {
  source                 = "../../modules/s3"
  github_repository_name = var.github_repository_name
  env                    = local.env
  bucket_name            = "read"
}

module "s3_write" {
  source                 = "../../modules/s3"
  github_repository_name = var.github_repository_name
  env                    = local.env
  bucket_name            = "write"
}

module "s3_contents" {
  source                 = "../../modules/s3"
  github_repository_name = var.github_repository_name
  env                    = local.env
  bucket_name            = "contents"
}
