output "cluster_id" {
  description = "AuroraクラスターのID"
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "AuroraクラスターのARN"
  value       = aws_rds_cluster.this.arn
}

output "cluster_endpoint" {
  description = "クラスターエンドポイント"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "クラスターリーダーエンドポイント"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_database_name" {
  description = "データベース名"
  value       = aws_rds_cluster.this.database_name
}

output "cluster_master_username" {
  description = "マスターユーザー名"
  value       = aws_rds_cluster.this.master_username
  sensitive   = true
}

output "cluster_master_user_secret" {
  description = "manage_master_user_passwordがtrueに設定されている場合の生成されたデータベースパスワード"
  value       = aws_rds_cluster.this.master_user_secret
  sensitive   = true
}

output "cluster_port" {
  description = "DBが接続を受け付けるポート"
  value       = aws_rds_cluster.this.port
}

output "cluster_engine_version_actual" {
  description = "データベースの実行中バージョン"
  value       = aws_rds_cluster.this.engine_version_actual
}

output "cluster_hosted_zone_id" {
  description = "エンドポイントのRoute53ホストゾーンID"
  value       = aws_rds_cluster.this.hosted_zone_id
}

output "cluster_resource_id" {
  description = "RDSクラスターリソースID"
  value       = aws_rds_cluster.this.cluster_resource_id
}

output "cluster_instances" {
  description = "RDSクラスターインスタンスのリスト"
  value = {
    for instance in aws_rds_cluster_instance.this : instance.identifier => {
      id                  = instance.id
      arn                 = instance.arn
      identifier          = instance.identifier
      endpoint            = instance.endpoint
      port                = instance.port
      engine_version      = instance.engine_version
      instance_class      = instance.instance_class
      publicly_accessible = instance.publicly_accessible
    }
  }
}

output "db_subnet_group_name" {
  description = "DBサブネットグループ名"
  value       = aws_db_subnet_group.this.name
}

output "security_group_ids" {
  description = "クラスターに関連付けられたセキュリティグループID"
  value       = aws_rds_cluster.this.vpc_security_group_ids
}

output "aurora_security_group_id" {
  description = "Aurora専用セキュリティグループのID"
  value       = var.create_security_group ? aws_security_group.aurora[0].id : null
}

output "db_parameter_group_name" {
  description = "DBパラメータグループ名"
  value       = var.create_parameter_group ? aws_db_parameter_group.this[0].name : var.db_parameter_group_name
}

output "db_cluster_parameter_group_name" {
  description = "DBクラスターパラメータグループ名"
  value       = var.create_cluster_parameter_group ? aws_rds_cluster_parameter_group.this[0].name : var.db_cluster_parameter_group_name
}
