module "dynamodb_users_table" {
  source = "../../../../modules/dynamodb"

  github_repository_name      = var.github_repository_name
  env                         = local.env
  table_name                  = "users"
  hash_key                    = "id"
  deletion_protection_enabled = false # サンプルであるため無効に設定

  attributes = [
    {
      name = "id"
      type = "N"
    },
  ]
}

module "dynamodb_sequences_table" {
  source = "../../../../modules/dynamodb"

  github_repository_name      = var.github_repository_name
  env                         = local.env
  table_name                  = "sequences"
  hash_key                    = "table_name"
  deletion_protection_enabled = false # サンプルであるため無効に設定

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
          S = "${var.github_repository_name}-${local.env}-users"
        }
        seq = {
          N = "0"
        }
      }
    }
  ]
}
