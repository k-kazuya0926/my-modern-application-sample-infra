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

module "dynamodb_sequences_table" {
  source = "../../modules/dynamodb"

  github_repository_name = var.github_repository_name
  env                    = local.env
  table_name             = "sequences"
  hash_key               = "table_name"

  attributes = [
    {
      name = "table_name"
      type = "S"
    },
  ]

  initial_items = [
    {
      item = {
        table_name = {
          S = "users"
        }
        seq = {
          N = "0"
        }
      }
    }
  ]
}
