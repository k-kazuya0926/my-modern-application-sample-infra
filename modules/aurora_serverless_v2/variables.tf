variable "github_repository_name" {
  description = "リソース命名用のGitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名 (例: prod, dev, staging)"
  type        = string
}

variable "cluster_name" {
  description = "Auroraクラスター名"
  type        = string
}

variable "engine_version" {
  description = "Aurora PostgreSQLエンジンバージョン"
  type        = string
  default     = "17.5"
}

variable "database_name" {
  description = "作成するデータベース名"
  type        = string
  default     = null
}

variable "master_username" {
  description = "データベースのマスターユーザー名"
  type        = string
  default     = "dbadmin"
}

variable "manage_master_user_password" {
  description = "RDSがSecrets Managerでマスターユーザーパスワードを管理することを許可する場合はtrueに設定"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "Aurora Serverless v2の最小キャパシティ"
  type        = number
  default     = 0.5
}

variable "max_capacity" {
  description = "Aurora Serverless v2の最大キャパシティ"
  type        = number
  default     = 1
}

variable "instance_count" {
  description = "クラスター内のインスタンス数"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPCのID（セキュリティグループ作成用）"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "DBサブネットグループ用のサブネットIDリスト"
  type        = list(string)
}

variable "create_security_group" {
  description = "Aurora用のセキュリティグループを作成するかどうか"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "Auroraへのアクセスを許可するCIDRブロックのリスト"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "追加で割り当てるVPCセキュリティグループIDのリスト"
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  description = "バックアップ保持期間（日数）"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "希望するバックアップ時間帯"
  type        = string
  default     = "07:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "希望するメンテナンス時間帯"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "deletion_protection" {
  description = "削除保護を有効化"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "クラスター削除時に最終スナップショットをスキップ"
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "CloudWatchにエクスポートするログタイプのリスト"
  type        = list(string)
  default     = ["postgresql"]
}

variable "performance_insights_enabled" {
  description = "Performance Insightsを有効化"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "拡張モニタリング間隔（秒）(0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 60
}

variable "seconds_until_auto_pause" {
  description = "自動一時停止までの秒数（min_capacityが0の場合のみ有効）。最小: 300秒、最大: 86400秒"
  type        = number
  default     = 300
}

variable "tags" {
  description = "リソースに割り当てるタグのマップ"
  type        = map(string)
  default     = {}
}