variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "queue_name" {
  description = "SQSキューの名前"
  type        = string
}

variable "delay_seconds" {
  description = "キュー内のすべてのメッセージの配信が遅延される時間（秒）"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Amazon SQSがメッセージを拒否する前にメッセージに含めることができる最大バイト数"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "Amazon SQSがメッセージを保持する秒数"
  type        = number
  default     = 345600 # 4 days
}

variable "receive_wait_time_seconds" {
  description = "ReceiveMessage呼び出しがメッセージの到着を待機する時間（秒）"
  type        = number
  default     = 0
}

variable "visibility_timeout_seconds" {
  description = "キューの可視性タイムアウト（秒）"
  type        = number
  default     = 30
}

variable "kms_master_key_id" {
  description = "Amazon SQS用のAWS管理カスタマーマスターキー（CMK）またはカスタムCMKのID"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Amazon SQSがメッセージの暗号化または復号化にデータキーを再利用できる時間の長さ（秒）"
  type        = number
  default     = 300
}

variable "dead_letter_queue_arn" {
  description = "ソースキューがメッセージの処理に失敗した後にメッセージを受信するデッドレターキューのARN"
  type        = string
  default     = null
}

variable "max_receive_count" {
  description = "メッセージがデッドレターキューに移動される前にソースキューに配信される回数"
  type        = number
  default     = 5
}

variable "create_dead_letter_queue" {
  description = "デッドレターキューを作成するかどうか"
  type        = bool
  default     = false
}

variable "dead_letter_retention_seconds" {
  description = "Amazon SQSがデッドレターキューでメッセージを保持する秒数"
  type        = number
  default     = 1209600 # 14 days
}

variable "queue_policy" {
  description = "SQSキューのJSONポリシー"
  type        = string
  default     = null
}

variable "tags" {
  description = "リソースに割り当てるタグのマップ"
  type        = map(string)
  default     = {}
}
