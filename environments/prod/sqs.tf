module "sqs_send_mail" {
  source = "../../modules/sqs"

  github_repository_name = var.github_repository_name
  env                    = local.env
  queue_name             = "send-mail"
}

module "sqs_fan_out_1" {
  source = "../../modules/sqs"

  github_repository_name = var.github_repository_name
  env                    = local.env
  queue_name             = "fan-out-1"

  queue_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_fan_out_1.queue_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_fan_out.topic_arn
          }
        }
      }
    ]
  })
}

module "sqs_fan_out_2" {
  source = "../../modules/sqs"

  github_repository_name = var.github_repository_name
  env                    = local.env
  queue_name             = "fan-out-2"

  queue_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_fan_out_2.queue_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_fan_out.topic_arn
          }
        }
      }
    ]
  })
}
