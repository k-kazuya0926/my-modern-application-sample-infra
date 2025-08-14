module "aurora_serverless_v2_default" {
  source = "../../../../modules/aurora_serverless_v2"

  github_repository_name = var.github_repository_name
  env                    = local.env
  cluster_name           = "default"
  database_name          = "default_db"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # セキュリティグループの許可IP範囲をVPC CIDRに限定
  allowed_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]

  # 暗号化設定
  storage_encrypted = true
  # kms_key_id は指定しない場合、AWS管理キーを使用

  # Data API設定
  enable_http_endpoint = true

  # IAMデータベース認証を有効化
  iam_database_authentication_enabled = true
  apply_immediately                   = true

  create_parameter_group         = true
  create_cluster_parameter_group = true

  cluster_parameters = [
    {
      name  = "timezone"
      value = "Asia/Tokyo"
    },
    {
      name  = "log_rotation_age"
      value = "1440" # 24時間
    },
    {
      name  = "log_rotation_size"
      value = "102400" # 100MB
    }
  ]

  instance_parameters = [
    # クエリの実行統計を取得
    {
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement"
      value        = "mod" # none/ddl/mod/all
      apply_method = "immediate"
    },
    # 1秒以上かかるクエリをログに出力
    {
      name         = "log_min_duration_statement"
      value        = "1000"
      apply_method = "immediate"
    },
    {
      name         = "log_connections"
      value        = "1"
      apply_method = "immediate"
    },
    {
      name         = "log_disconnections"
      value        = "1"
      apply_method = "immediate"
    }
  ]

  # サンプル用の設定
  backup_retention_period      = 1
  skip_final_snapshot          = true
  deletion_protection          = false
  performance_insights_enabled = false
  monitoring_interval          = 0
  log_retention_days           = 7
}
