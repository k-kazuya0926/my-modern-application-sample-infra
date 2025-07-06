output "users_table_arn" {
  description = "usersテーブルのARN"
  value       = module.dynamodb_users_table.table_arn
}

output "sequences_table_arn" {
  description = "sequencesテーブルのARN"
  value       = module.dynamodb_sequences_table.table_arn
}
