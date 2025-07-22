variable "name_prefix" {
  description = "全リソース名のプレフィックス"
  type        = string
}

variable "cluster_id" {
  description = "ECSクラスターのID"
  type        = string
}

variable "cluster_name" {
  description = "ECSクラスター名（オートスケーリング用）"
  type        = string
}

variable "task_family" {
  description = "ECSタスク定義のファミリー名"
  type        = string
}

variable "container_name" {
  description = "コンテナ名"
  type        = string
}

variable "image_uri" {
  description = "コンテナイメージのURI（ECRリポジトリのURI）"
  type        = string
}

variable "cpu" {
  description = "タスクのCPUユニット数"
  type        = number
  default     = 256

  validation {
    condition = contains([
      256, 512, 1024, 2048, 4096
    ], var.cpu)
    error_message = "CPU は有効なFargateのCPU値である必要があります（256, 512, 1024, 2048, 4096）。"
  }
}

variable "memory" {
  description = "タスクのメモリ量（MB）"
  type        = number
  default     = 512

  validation {
    condition = var.memory >= 512 && var.memory <= 30720
    error_message = "メモリは512MB以上30720MB以下である必要があります。"
  }
}

variable "desired_count" {
  description = "ECSサービスの希望タスク数"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "ECSタスクを配置するサブネットIDのリスト"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "タスクにパブリックIPを割り当てるかどうか"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "コンテナの環境変数"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets Managerからのシークレット設定"
  type = list(object({
    name      = string
    value_from = string
  }))
  default = []
}

variable "secrets_manager_arns" {
  description = "Secrets ManagerのARNリスト（タスク実行ロールでアクセス許可）"
  type        = list(string)
  default     = []
}

variable "port_mappings" {
  description = "コンテナのポートマッピング設定"
  type = list(object({
    containerPort = number
    protocol      = string
  }))
  default = []
}

variable "ingress_rules" {
  description = "セキュリティグループのインバウンドルール"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日）"
  type        = number
  default     = 7

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.log_retention_days)
    error_message = "log_retention_days は有効なCloudWatch Logsの保持期間である必要があります。"
  }
}

variable "capacity_provider" {
  description = "使用する容量プロバイダー"
  type        = string
  default     = "FARGATE"

  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.capacity_provider)
    error_message = "capacity_provider は FARGATE または FARGATE_SPOT である必要があります。"
  }
}

variable "enable_load_balancer" {
  description = "ロードバランサー統合を有効にするかどうか"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ターゲットグループのARN（ALB使用時）"
  type        = string
  default     = null
}

variable "container_port" {
  description = "ロードバランサーがアクセスするコンテナポート"
  type        = number
  default     = 80
}

variable "enable_execute_command" {
  description = "ECS Execコマンドを有効にするかどうか"
  type        = bool
  default     = false
}

variable "deployment_maximum_percent" {
  description = "デプロイメント時の最大タスク数のパーセンテージ"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "デプロイメント時の最小健全タスク数のパーセンテージ"
  type        = number
  default     = 100
}

variable "enable_health_check" {
  description = "ヘルスチェックを有効にするかどうか"
  type        = bool
  default     = false
}

variable "health_check_command" {
  description = "ヘルスチェックコマンド"
  type        = list(string)
  default     = ["CMD-SHELL", "exit 0"]
}

variable "health_check_interval" {
  description = "ヘルスチェック間隔（秒）"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "ヘルスチェックタイムアウト（秒）"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "ヘルスチェック再試行回数"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "ヘルスチェック開始猶予期間（秒）"
  type        = number
  default     = 60
}

variable "enable_autoscaling" {
  description = "オートスケーリングを有効にするかどうか"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "オートスケーリングの最小キャパシティ"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "オートスケーリングの最大キャパシティ"
  type        = number
  default     = 10
}

variable "cpu_target_value" {
  description = "CPUベースのオートスケーリングターゲット値（%）"
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "メモリベースのオートスケーリングターゲット値（%）"
  type        = number
  default     = 80
}

variable "policy_statements" {
  description = "ECSタスクロールに追加するIAMポリシーステートメント"
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}