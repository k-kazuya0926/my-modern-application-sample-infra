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
