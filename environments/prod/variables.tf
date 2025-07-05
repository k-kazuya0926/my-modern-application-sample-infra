variable "github_owner_name" {
  type        = string
  description = "GitHubオーナー名"
}

variable "github_repository_name" {
  type        = string
  description = "GitHubリポジトリ名"
}

variable "ses_email_addresses" {
  type        = list(string)
  description = "SESで認証するメールアドレスのリスト"
}

variable "mail_from" {
  type        = string
  description = "メール送信時のFromアドレス"
}
