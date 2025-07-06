output "queue_id" {
  description = "作成されたAmazon SQSキューのURL"
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "SQSキューのARN"
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "SQSキューの名前"
  value       = aws_sqs_queue.this.name
}

output "queue_url" {
  description = "queue_idと同じ：作成されたAmazon SQSキューのURL"
  value       = aws_sqs_queue.this.url
}

output "dead_letter_queue_id" {
  description = "作成されたAmazon SQSデッドレターキューのURL"
  value       = var.create_dead_letter_queue ? aws_sqs_queue.dead_letter[0].id : null
}

output "dead_letter_queue_arn" {
  description = "SQSデッドレターキューのARN"
  value       = var.create_dead_letter_queue ? aws_sqs_queue.dead_letter[0].arn : null
}

output "dead_letter_queue_name" {
  description = "SQSデッドレターキューの名前"
  value       = var.create_dead_letter_queue ? aws_sqs_queue.dead_letter[0].name : null
}

output "dead_letter_queue_url" {
  description = "作成されたAmazon SQSデッドレターキューのURL"
  value       = var.create_dead_letter_queue ? aws_sqs_queue.dead_letter[0].url : null
}
