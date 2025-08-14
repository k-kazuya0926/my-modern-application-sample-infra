# SESメールアドレス認証
resource "aws_ses_email_identity" "this" {
  count = length(var.email_addresses)
  email = var.email_addresses[count.index]
}

# SESバウンス通知設定
resource "aws_ses_identity_notification_topic" "bounce" {
  count                    = var.bounce_topic_arn != null ? length(var.email_addresses) : 0
  topic_arn                = var.bounce_topic_arn
  notification_type        = "Bounce"
  identity                 = aws_ses_email_identity.this[count.index].email
  include_original_headers = true
}
