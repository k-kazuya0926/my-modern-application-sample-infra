module "ses" {
  source = "../../modules/ses"

  email_addresses = var.ses_email_addresses
}
