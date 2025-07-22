# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name = "${var.name_prefix}-ecs-cluster"
  }
}

# ECSクラスター容量プロバイダー
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}