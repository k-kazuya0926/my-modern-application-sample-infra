module "aurora_default" {
  source = "../../../../modules/aurora_serverless_v2"

  github_repository_name = var.github_repository_name
  env                    = local.env
  cluster_name           = "default"
  database_name          = "default_db"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # サンプル用の設定
  backup_retention_period      = 1
  skip_final_snapshot          = true
  deletion_protection          = false
  performance_insights_enabled = false
  monitoring_interval          = 0

  # セキュリティグループの許可IP範囲をVPC CIDRに限定
  allowed_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]

  # パラメーターグループとオプショングループの作成を有効化
  create_parameter_group         = true
  create_cluster_parameter_group = true
  create_option_group            = true

  # クラスターパラメータの例
  cluster_parameters = [
    {
      name  = "log_statement"
      value = "all"
    },
    {
      name  = "log_min_duration_statement"
      value = "1000"
    }
  ]

  # インスタンスパラメータの例
  instance_parameters = [
    {
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
      apply_method = "pending-reboot"
    }
  ]
}
