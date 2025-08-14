data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_db_parameter_group" "this" {
  count  = var.create_parameter_group ? 1 : 0
  name   = "${var.github_repository_name}-${var.env}-${var.cluster_name}-db-params"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.instance_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.cluster_name}-db-params"
  })
}

resource "aws_rds_cluster_parameter_group" "this" {
  count  = var.create_cluster_parameter_group ? 1 : 0
  name   = "${var.github_repository_name}-${var.env}-${var.cluster_name}-cluster-params"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.cluster_name}-cluster-params"
  })
}

# Aurora Serverless v2はオプショングループをサポートしていないため、
# 必要な設定はパラメータグループで行います。

# Aurora用セキュリティグループ
resource "aws_security_group" "aurora" {
  count = var.create_security_group ? 1 : 0

  name        = "${var.github_repository_name}-${var.env}-${var.cluster_name}-aurora-sg"
  description = "Security group for Aurora Serverless v2 cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.cluster_name}-aurora-sg"
  })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier          = "${var.github_repository_name}-${var.env}-${var.cluster_name}"
  engine                      = "aurora-postgresql"
  engine_mode                 = "provisioned"
  engine_version              = var.engine_version
  database_name               = var.database_name
  master_username             = var.master_username
  manage_master_user_password = var.manage_master_user_password

  # 暗号化設定
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  # RDS延長サポートの設定（作成時のみ設定可能）
  engine_lifecycle_support = var.extended_support_enabled ? null : "open-source-rds-extended-support-disabled"

  serverlessv2_scaling_configuration {
    max_capacity             = var.max_capacity
    min_capacity             = var.min_capacity
    seconds_until_auto_pause = var.min_capacity == 0 ? var.seconds_until_auto_pause : null
  }

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.create_security_group ? concat([aws_security_group.aurora[0].id], var.vpc_security_group_ids) : var.vpc_security_group_ids

  db_cluster_parameter_group_name = var.create_cluster_parameter_group ? aws_rds_cluster_parameter_group.this[0].name : var.db_cluster_parameter_group_name

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.github_repository_name}-${var.env}-${var.cluster_name}-final-snapshot"

  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  enable_http_endpoint                = var.enable_http_endpoint
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  apply_immediately                   = var.apply_immediately

  tags = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.github_repository_name}-${var.env}-${var.cluster_name}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_parameter_group_name = var.create_parameter_group ? aws_db_parameter_group.this[0].name : var.db_parameter_group_name

  performance_insights_enabled = var.performance_insights_enabled
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = var.monitoring_interval > 0 ? aws_iam_role.rds_enhanced_monitoring[0].arn : null

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.github_repository_name}-${var.env}-${var.cluster_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.cluster_name}-subnet-group"
  })
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0
  name  = "${var.github_repository_name}-${var.env}-${var.cluster_name}-rds-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# CloudWatch Logs Groups for RDS logs
resource "aws_cloudwatch_log_group" "postgresql" {
  count             = contains(var.enabled_cloudwatch_logs_exports, "postgresql") ? 1 : 0
  name              = "/aws/rds/cluster/${aws_rds_cluster.this.cluster_identifier}/postgresql"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.cluster_name}-postgresql-logs"
  })
}

# IAM認証用のpostgresユーザーにrds_iam権限を付与
resource "null_resource" "grant_rds_iam_to_postgres" {
  count = var.iam_database_authentication_enabled ? 1 : 0

  depends_on = [aws_rds_cluster_instance.this]

  provisioner "local-exec" {
    command = <<-EOT
      # RDSクラスターが完全に利用可能になるまで待機
      echo "Waiting for RDS cluster to be available..."
      aws rds wait db-cluster-available --db-cluster-identifier "${aws_rds_cluster.this.cluster_identifier}"
      
      # GRANT rds_iam TO postgres を実行
      echo "Executing GRANT rds_iam TO postgres..."
      aws rds-data execute-statement \
        --resource-arn "${aws_rds_cluster.this.arn}" \
        --secret-arn "${aws_rds_cluster.this.master_user_secret[0].secret_arn}" \
        --database "${var.database_name}" \
        --sql "GRANT rds_iam TO postgres;"
      
      # 結果を確認
      echo "Verifying GRANT execution..."
      RESULT=$(aws rds-data execute-statement \
        --resource-arn "${aws_rds_cluster.this.arn}" \
        --secret-arn "${aws_rds_cluster.this.master_user_secret[0].secret_arn}" \
        --database "${var.database_name}" \
        --sql "SELECT pg_has_role('postgres', 'rds_iam', 'MEMBER') as has_rds_iam_role;" \
        --query 'records[0][0].booleanValue' \
        --output text)
      
      if [ "$RESULT" = "True" ]; then
        echo "SUCCESS: rds_iam role granted to postgres user"
      else
        echo "ERROR: Failed to grant rds_iam role to postgres user"
        exit 1
      fi
    EOT
  }

  triggers = {
    cluster_id = aws_rds_cluster.this.id
    # 強制再実行のためのタイムスタンプ
    timestamp = timestamp()
  }
}
