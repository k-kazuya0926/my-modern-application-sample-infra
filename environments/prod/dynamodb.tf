module "dynamodb_users_table" {
  source = "../../modules/dynamodb"

  github_repository_name = var.github_repository_name
  env                    = local.env
  table_name             = "users"
  hash_key               = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    },
  ]
}
