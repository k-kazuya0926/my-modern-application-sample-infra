data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.name_prefix}-${var.task_family}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.name_prefix}-${var.task_family}-logs"
  }
}

# ECSタスク実行ロール
resource "aws_iam_role" "execution_role" {
  name               = "${var.name_prefix}-${var.task_family}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = {
    Name = "${var.name_prefix}-${var.task_family}-execution-role"
  }
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECSタスク実行ロール用ポリシー
data "aws_iam_policy_document" "execution_policy" {
  # ECRからのイメージプル権限
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }

  # CloudWatch Logsの権限
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.ecs_logs.arn}:*"]
  }

  # Secrets Managerからのシークレット取得（オプション）
  dynamic "statement" {
    for_each = var.secrets_manager_arns
    content {
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue"
      ]
      resources = [statement.value]
    }
  }
}

resource "aws_iam_policy" "execution_policy" {
  name   = "${var.name_prefix}-${var.task_family}-execution-policy"
  policy = data.aws_iam_policy_document.execution_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
}

# ECSタスクロール
resource "aws_iam_role" "task_role" {
  name               = "${var.name_prefix}-${var.task_family}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = {
    Name = "${var.name_prefix}-${var.task_family}-task-role"
  }
}

# ECSタスクロール用ポリシー（動的ステートメント）
data "aws_iam_policy_document" "task_policy" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "task_policy" {
  count  = length(var.policy_statements) > 0 ? 1 : 0
  name   = "${var.name_prefix}-${var.task_family}-task-policy"
  policy = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role_policy_attachment" "task_policy" {
  count      = length(var.policy_statements) > 0 ? 1 : 0
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy[0].arn
}

# ECSタスク定義
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name_prefix}-${var.task_family}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.image_uri
      
      portMappings = var.port_mappings

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]

      secrets = [
        for secret in var.secrets : {
          name      = secret.name
          valueFrom = secret.value_from
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true

      healthCheck = var.enable_health_check ? {
        command     = var.health_check_command
        interval    = var.health_check_interval
        timeout     = var.health_check_timeout
        retries     = var.health_check_retries
        startPeriod = var.health_check_start_period
      } : null
    }
  ])

  tags = {
    Name = "${var.name_prefix}-${var.task_family}"
  }
}

# セキュリティグループ
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.name_prefix}-${var.task_family}-"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-${var.task_family}-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ECSサービス
resource "aws_ecs_service" "main" {
  name            = "${var.name_prefix}-${var.task_family}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  enable_execute_command = var.enable_execute_command

  deployment_configuration {
    maximum_percent         = var.deployment_maximum_percent
    minimum_healthy_percent = var.deployment_minimum_healthy_percent
  }

  tags = {
    Name = "${var.name_prefix}-${var.task_family}-service"
  }

  depends_on = [aws_iam_role_policy_attachment.execution_policy]

  lifecycle {
    ignore_changes = [task_definition]
  }
}

# Application Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Application Auto Scaling Policy - CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.name_prefix}-${var.task_family}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
}

# Application Auto Scaling Policy - Memory
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.name_prefix}-${var.task_family}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_value
  }
}