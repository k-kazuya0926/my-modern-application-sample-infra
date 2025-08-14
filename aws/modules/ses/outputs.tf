output "email_identities" {
  description = "SESメールアドレスアイデンティティのリスト"
  value       = aws_ses_email_identity.this[*].email
}

output "email_identity_arns" {
  description = "SESメールアドレスアイデンティティのARNリスト"
  value       = aws_ses_email_identity.this[*].arn
}
