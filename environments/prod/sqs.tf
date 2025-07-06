module "sqs_send_mail" {
  source = "../../modules/sqs"

  github_repository_name = var.github_repository_name
  env                    = local.env
  queue_name             = "send-mail"
}
