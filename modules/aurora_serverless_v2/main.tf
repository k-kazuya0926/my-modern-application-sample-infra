data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
  cluster_identifier      = "${var.github_repository_name}-${var.env}-${var.cluster_name}"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  manage_master_user_password = var.manage_master_user_password
  
  serverlessv2_scaling_configuration {
    max_capacity             = var.max_capacity
    min_capacity             = var.min_capacity
    seconds_until_auto_pause = var.min_capacity == 0 ? var.seconds_until_auto_pause : null
  }

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.create_security_group ? concat([aws_security_group.aurora[0].id], var.vpc_security_group_ids) : var.vpc_security_group_ids
  
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.github_repository_name}-${var.env}-${var.cluster_name}-final-snapshot"
  
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  tags = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.github_repository_name}-${var.env}-${var.cluster_name}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  
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