output "users_table_arn" {
  description = "usersテーブルのARN"
  value       = module.dynamodb_users_table.table_arn
}

output "sequences_table_arn" {
  description = "sequencesテーブルのARN"
  value       = module.dynamodb_sequences_table.table_arn
}

output "mail_addresses_table_arn" {
  description = "mail_addressesテーブルのARN"
  value       = module.dynamodb_mail_addresses_table.table_arn
}

output "mail_addresses_table_name" {
  description = "mail_addressesテーブル名"
  value       = module.dynamodb_mail_addresses_table.table_name
}
