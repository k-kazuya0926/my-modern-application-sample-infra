variable "email_addresses" {
  type        = list(string)
  description = "SESで認証するメールアドレスのリスト"
}

variable "bounce_topic_arn" {
  type        = string
  description = "バウンス通知を送信するSNSトピックのARN"
  default     = null
}
