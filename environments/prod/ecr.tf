module "ecr_hello_world" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "hello-world"
}

module "ecr_tmp" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "tmp"
}

module "ecr_read_and_write_s3" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "read-and-write-s3"
}

module "ecr_register_user" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "register-user"
}

module "ecr_send_message" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "send-message"
}

module "ecr_read_message_and_send_mail" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "read-message-and-send-mail"
}

module "ecr_receive_bounce_mail" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "receive-bounce-mail"
}

module "ecr_feature_flags" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "feature-flags"
}

module "ecr_auth_by_cognito" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "auth-by-cognito"
}

module "ecr_process_payment" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "process-payment"
}

module "ecr_cancel_payment" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "cancel-payment"
}

module "ecr_create_purchase_history" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "create-purchase-history"
}

module "ecr_delete_purchase_history" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "delete-purchase-history"
}

module "ecr_award_points" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "award-points"
}

module "ecr_fan_out_consumer_1" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "fan-out-consumer-1"
}

module "ecr_fan_out_consumer_2" {
  source                 = "../../modules/ecr"
  github_repository_name = var.github_repository_name
  env                    = local.env
  ecr_repository_name    = "fan-out-consumer-2"
}
