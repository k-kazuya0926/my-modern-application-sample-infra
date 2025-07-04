output "table_name" {
  description = "DynamoDBテーブル名"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDBテーブルのARN"
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "DynamoDBテーブルのID"
  value       = aws_dynamodb_table.this.id
}

output "table_stream_arn" {
  description = "DynamoDBストリームのARN"
  value       = aws_dynamodb_table.this.stream_arn
}

output "table_stream_label" {
  description = "DynamoDBストリームのラベル"
  value       = aws_dynamodb_table.this.stream_label
}
