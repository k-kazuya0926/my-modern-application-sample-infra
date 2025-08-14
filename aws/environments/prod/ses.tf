module "ses" {
  source = "../../modules/ses"

  email_addresses  = var.ses_email_addresses
  bounce_topic_arn = module.sns_bounce_notifications.topic_arn
}
