output "topic_id" {
  description = "SNSトピックのID"
  value       = aws_sns_topic.this.id
}

output "topic_arn" {
  description = "SNSトピックのARN"
  value       = aws_sns_topic.this.arn
}

output "topic_name" {
  description = "SNSトピックの名前"
  value       = aws_sns_topic.this.name
}

output "topic_display_name" {
  description = "SNSトピックの表示名"
  value       = aws_sns_topic.this.display_name
}

output "topic_owner" {
  description = "SNSトピックの所有者のAWSアカウントID"
  value       = aws_sns_topic.this.owner
}

output "subscription_arns" {
  description = "SNSトピック購読のARNリスト"
  value       = aws_sns_topic_subscription.this[*].arn
}

output "subscription_ids" {
  description = "SNSトピック購読のIDリスト"
  value       = aws_sns_topic_subscription.this[*].id
}

output "lambda_subscription_arns" {
  description = "Lambda関数のSNSトピック購読のARNリスト"
  value       = aws_sns_topic_subscription.lambda[*].arn
}

output "lambda_subscription_ids" {
  description = "Lambda関数のSNSトピック購読のIDリスト"
  value       = aws_sns_topic_subscription.lambda[*].id
}

output "lambda_permission_ids" {
  description = "Lambda関数のSNS呼び出し権限のIDリスト"
  value       = aws_lambda_permission.allow_sns_invoke[*].id
}
