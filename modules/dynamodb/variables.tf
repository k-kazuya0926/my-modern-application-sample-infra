variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "table_name" {
  description = "DynamoDBテーブル名"
  type        = string
}

variable "billing_mode" {
  description = "課金モード (PROVISIONED または PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "ハッシュキー（パーティションキー）"
  type        = string
}

variable "range_key" {
  description = "レンジキー（ソートキー）"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "読み取りキャパシティユニット（PROVISIONEDモード時のみ）"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "書き込みキャパシティユニット（PROVISIONEDモード時のみ）"
  type        = number
  default     = 5
}

variable "attributes" {
  description = "テーブルの属性定義"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "グローバルセカンダリインデックス"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "ローカルセカンダリインデックス"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = string
  }))
  default = []
}

variable "ttl_enabled" {
  description = "TTL（Time To Live）を有効にするか"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "TTL属性名"
  type        = string
  default     = "expires_at"
}

variable "point_in_time_recovery_enabled" {
  description = "ポイントインタイムリカバリを有効にするか"
  type        = bool
  default     = false
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
