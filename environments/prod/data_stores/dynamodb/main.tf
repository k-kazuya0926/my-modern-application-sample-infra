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

module "dynamodb_mail_addresses_table" {
  source = "../../../../modules/dynamodb"

  github_repository_name      = var.github_repository_name
  env                         = local.env
  table_name                  = "mail_addresses"
  hash_key                    = "email"
  deletion_protection_enabled = false # サンプルであるため無効に設定

  attributes = [
    {
      name = "email"
      type = "S"
    },
    {
      name = "has_error"
      type = "N"
    },
  ]

  global_secondary_indexes = [
    {
      name            = "has_error-index"
      hash_key        = "has_error"
      projection_type = "ALL"
    },
  ]

  initial_items = [
    {
      item = {
        email = {
          S = "success@simulator.amazonses.com"
        }
        user_name = {
          S = "success"
        }
        has_error = {
          N = "0"
        }
        is_sent = {
          N = "0"
        }
      }
    },
    {
      item = {
        email = {
          S = "bounce@simulator.amazonses.com"
        }
        user_name = {
          S = "bounce"
        }
        has_error = {
          N = "0"
        }
        is_sent = {
          N = "0"
        }
      }
    },
    {
      item = {
        email = {
          S = "ooto@simulator.amazonses.com"
        }
        user_name = {
          S = "ooto"
        }
        has_error = {
          N = "0"
        }
        is_sent = {
          N = "0"
        }
      }
    },
    {
      item = {
        email = {
          S = "complaint@simulator.amazonses.com"
        }
        user_name = {
          S = "complaint"
        }
        has_error = {
          N = "0"
        }
        is_sent = {
          N = "0"
        }
      }
    },
    {
      item = {
        email = {
          S = "suppressionlist@simulator.amazonses.com"
        }
        user_name = {
          S = "suppressionlist"
        }
        has_error = {
          N = "0"
        }
        is_sent = {
          N = "0"
        }
      }
    }
  ]
}
