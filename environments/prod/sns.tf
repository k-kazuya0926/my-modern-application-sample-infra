module "sns_bounce_notifications" {
  source = "../../modules/sns"

  github_repository_name = var.github_repository_name
  env                    = local.env
  topic_name             = "bounce-notifications"

  # スタンダードタイプ（FIFOではない）
  fifo_topic = false
}
