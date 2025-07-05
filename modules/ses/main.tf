# SESメールアドレス認証
resource "aws_ses_email_identity" "this" {
  count = length(var.email_addresses)
  email = var.email_addresses[count.index]
}
