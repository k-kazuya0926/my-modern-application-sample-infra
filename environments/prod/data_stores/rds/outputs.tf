output "cluster_endpoint" {
  description = "Auroraクラスターエンドポイント"
  value       = module.aurora_serverless_v2_default.cluster_endpoint
}

output "database_name" {
  description = "データベース名"
  value       = module.aurora_serverless_v2_default.cluster_database_name
}

output "cluster_arn" {
  description = "AuroraクラスターのARN"
  value       = module.aurora_serverless_v2_default.cluster_arn
}

output "cluster_id" {
  description = "AuroraクラスターのID"
  value       = module.aurora_serverless_v2_default.cluster_id
}

output "cluster_port" {
  description = "DBが接続を受け付けるポート"
  value       = module.aurora_serverless_v2_default.cluster_port
}

output "cluster_reader_endpoint" {
  description = "クラスターリーダーエンドポイント"
  value       = module.aurora_serverless_v2_default.cluster_reader_endpoint
}

output "security_group_ids" {
  description = "クラスターに関連付けられたセキュリティグループID"
  value       = module.aurora_serverless_v2_default.security_group_ids
}