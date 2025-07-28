module "lambda_hello_world" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "hello-world"
  image_uri              = "${module.ecr_hello_world.repository_url}:dummy"
}

module "lambda_tmp" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "tmp"
  image_uri              = "${module.ecr_tmp.repository_url}:dummy"
}

module "lambda_read_and_write_s3" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "read-and-write-s3"
  image_uri              = "${module.ecr_read_and_write_s3.repository_url}:dummy"
  environment_variables = {
    OUTPUT_BUCKET = module.s3_write.bucket_name
  }

  s3_trigger_bucket_name = module.s3_read.bucket_name
  s3_trigger_bucket_arn  = module.s3_read.bucket_arn

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      resources = [
        module.s3_read.bucket_arn,
        "${module.s3_read.bucket_arn}/*"
      ]
    },
    {
      effect = "Allow"
      actions = [
        "s3:PutObject"
      ]
      resources = [
        "${module.s3_write.bucket_arn}/*"
      ]
    }
  ]
}

module "lambda_register_user" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "register-user"
  image_uri              = "${module.ecr_register_user.repository_url}:dummy"
  environment_variables = {
    ENV             = local.env
    CONTENTS_BUCKET = module.s3_contents.bucket_name
    FILE_NAME       = "special.txt"
    MAIL_FROM       = var.mail_from
  }

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "s3:GetObject"
      ]
      resources = [
        module.s3_contents.bucket_arn,
        "${module.s3_contents.bucket_arn}/*"
      ]
    },
    {
      effect = "Allow"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      resources = [
        data.terraform_remote_state.dynamodb.outputs.users_table_arn,
        data.terraform_remote_state.dynamodb.outputs.sequences_table_arn
      ]
    },
    {
      effect = "Allow"
      actions = [
        "ses:SendEmail"
      ]
      resources = [
        "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/*"
      ]
    }
  ]
}

module "lambda_send_message" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "send-message"
  image_uri              = "${module.ecr_send_message.repository_url}:dummy"
  environment_variables = {
    ENV = local.env
  }
  s3_trigger_bucket_name = module.s3_mail_body.bucket_name
  s3_trigger_bucket_arn  = module.s3_mail_body.bucket_arn
  enable_tracing         = true

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "dynamodb:Query"
      ]
      resources = [
        "${data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn}/index/has_error-index"
      ]
    },
    {
      effect = "Allow"
      actions = [
        "dynamodb:UpdateItem"
      ]
      resources = [
        data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
      ]
    },
    {
      effect = "Allow"
      actions = [
        "sqs:SendMessage",
        "sqs:GetQueueUrl"
      ]
      resources = [
        module.sqs_send_mail.queue_arn
      ]
    }
  ]
}

module "lambda_read_message_and_send_mail" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "read-message-and-send-mail"
  image_uri              = "${module.ecr_read_message_and_send_mail.repository_url}:dummy"
  environment_variables = {
    ENV       = local.env
    MAIL_FROM = var.mail_from
  }
  sqs_trigger_queue_arn = module.sqs_send_mail.queue_arn
  enable_tracing        = true

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "s3:GetObject"
      ]
      resources = [
        "${module.s3_mail_body.bucket_arn}/*"
      ]
    },
    {
      effect = "Allow"
      actions = [
        "dynamodb:UpdateItem"
      ]
      resources = [
        data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
      ]
    },
    {
      effect = "Allow"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      resources = [
        module.sqs_send_mail.queue_arn
      ]
    },
    {
      effect = "Allow"
      actions = [
        "ses:SendEmail"
      ]
      resources = [
        "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/*"
      ]
    }
  ]
}

module "lambda_receive_bounce_mail" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "receive-bounce-mail"
  image_uri              = "${module.ecr_receive_bounce_mail.repository_url}:dummy"
  environment_variables = {
    ENV        = local.env
    MAIL_TABLE = data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_name
  }
  enable_tracing = true

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "dynamodb:UpdateItem"
      ]
      resources = [
        data.terraform_remote_state.dynamodb.outputs.mail_addresses_table_arn
      ]
    }
  ]
}

module "lambda_feature_flags" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "feature-flags"
  image_uri              = "${module.ecr_feature_flags.repository_url}:dummy"
  environment_variables = {
    APPCONFIG_APPLICATION_ID           = module.appconfig_feature_flags.application_id
    APPCONFIG_ENVIRONMENT_ID           = module.appconfig_feature_flags.environment_id
    APPCONFIG_CONFIGURATION_PROFILE_ID = module.appconfig_feature_flags.configuration_profile_id
  }

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "appconfig:StartConfigurationSession",
        "appconfig:GetLatestConfiguration"
      ]
      resources = [
        "arn:aws:appconfig:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:application/${module.appconfig_feature_flags.application_id}/environment/${module.appconfig_feature_flags.environment_id}/configuration/${module.appconfig_feature_flags.configuration_profile_id}"
      ]
    }
  ]
}

module "lambda_auth_by_cognito" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "auth-by-cognito"
  image_uri              = "${module.ecr_auth_by_cognito.repository_url}:dummy"
}

module "lambda_process_payment" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "process-payment"
  image_uri              = "${module.ecr_process_payment.repository_url}:dummy"
}

module "lambda_cancel_payment" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "cancel-payment"
  image_uri              = "${module.ecr_cancel_payment.repository_url}:dummy"
}

module "lambda_create_purchase_history" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "create-purchase-history"
  image_uri              = "${module.ecr_create_purchase_history.repository_url}:dummy"
}

module "lambda_delete_purchase_history" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "delete-purchase-history"
  image_uri              = "${module.ecr_delete_purchase_history.repository_url}:dummy"
}

module "lambda_award_points" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "award-points"
  image_uri              = "${module.ecr_award_points.repository_url}:dummy"
}

module "lambda_fan_out_consumer_1" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "fan-out-consumer-1"
  image_uri              = "${module.ecr_fan_out_consumer_1.repository_url}:dummy"
  environment_variables = {
    ENV = local.env
  }
  sqs_trigger_queue_arn = module.sqs_fan_out_1.queue_arn
  enable_tracing        = false

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      resources = [
        module.sqs_fan_out_1.queue_arn
      ]
    }
  ]
}

module "lambda_fan_out_consumer_2" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "fan-out-consumer-2"
  image_uri              = "${module.ecr_fan_out_consumer_2.repository_url}:dummy"
  environment_variables = {
    ENV = local.env
  }
  sqs_trigger_queue_arn = module.sqs_fan_out_2.queue_arn
  enable_tracing        = false

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      resources = [
        module.sqs_fan_out_2.queue_arn
      ]
    }
  ]
}

module "lambda_access_rds" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "access-rds"
  image_uri              = "${module.ecr_access_rds.repository_url}:dummy"
  timeout                = 30

  environment_variables = {
    ENV           = local.env
    DATABASE_HOST = data.terraform_remote_state.rds.outputs.cluster_endpoint
    DATABASE_NAME = data.terraform_remote_state.rds.outputs.database_name
    DATABASE_PORT = "5432"
  }

  vpc_config = {
    subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_access_rds.id]
  }

  policy_statements = [
    {
      effect = "Allow"
      actions = [
        "rds-data:BatchExecuteStatement",
        "rds-data:BeginTransaction",
        "rds-data:CommitTransaction",
        "rds-data:ExecuteStatement",
        "rds-data:RollbackTransaction"
      ]
      resources = [
        data.terraform_remote_state.rds.outputs.cluster_arn
      ]
    },
    {
      effect = "Allow"
      actions = [
        "rds-db:connect"
      ]
      resources = [
        "arn:aws:rds-db:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:dbuser:${data.terraform_remote_state.rds.outputs.cluster_resource_id}/postgres"
      ]
    }
  ]
}

# Lambda to VPC セキュリティグループ
resource "aws_security_group" "lambda_access_rds" {
  name        = "${var.github_repository_name}-${local.env}-lambda-access-rds"
  description = "Security group for Lambda functions to access VPC"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
    description = "PostgreSQL/Aurora access"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS for AWS API calls"
  }

  tags = {
    Name        = "${var.github_repository_name}-${local.env}-lambda-access-rds"
    Environment = local.env
  }
}
