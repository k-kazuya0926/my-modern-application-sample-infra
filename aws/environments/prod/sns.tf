module "sns_bounce_notifications" {
  source = "../../modules/sns"

  github_repository_name = var.github_repository_name
  env                    = local.env
  topic_name             = "bounce-notifications"

  # スタンダードタイプ（FIFOではない）
  fifo_topic = false

  # Lambda関数のサブスクリプション
  lambda_subscriptions = [
    {
      function_name = module.lambda_receive_bounce_mail.function_name
      function_arn  = module.lambda_receive_bounce_mail.function_arn
    }
  ]
}

module "sns_fan_out" {
  source = "../../modules/sns"

  github_repository_name = var.github_repository_name
  env                    = local.env
  topic_name             = "fan-out"

  # スタンダードタイプ（FIFOではない）
  fifo_topic = false

  # SQSキューのサブスクリプション
  subscriptions = [
    {
      protocol            = "sqs"
      endpoint            = module.sqs_fan_out_1.queue_arn
      filter_policy       = null
      filter_policy_scope = null
    },
    {
      protocol            = "sqs"
      endpoint            = module.sqs_fan_out_2.queue_arn
      filter_policy       = null
      filter_policy_scope = null
    }
  ]
}
