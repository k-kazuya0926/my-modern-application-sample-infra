variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

variable "topic_name" {
  description = "SNSトピック名"
  type        = string
}

variable "display_name" {
  description = "SNSトピックの表示名"
  type        = string
  default     = null
}

variable "topic_policy" {
  description = "SNSトピックのアクセスポリシー（JSON形式）"
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "SNSトピックの配信ポリシー（JSON形式）"
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "アプリケーション配信成功フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "アプリケーション配信成功フィードバックのサンプルレート（0-100）"
  type        = number
  default     = null
}

variable "application_failure_feedback_role_arn" {
  description = "アプリケーション配信失敗フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "http_success_feedback_role_arn" {
  description = "HTTP配信成功フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "HTTP配信成功フィードバックのサンプルレート（0-100）"
  type        = number
  default     = null
}

variable "http_failure_feedback_role_arn" {
  description = "HTTP配信失敗フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  description = "Lambda配信成功フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Lambda配信成功フィードバックのサンプルレート（0-100）"
  type        = number
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  description = "Lambda配信失敗フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "SQS配信成功フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "SQS配信成功フィードバックのサンプルレート（0-100）"
  type        = number
  default     = null
}

variable "sqs_failure_feedback_role_arn" {
  description = "SQS配信失敗フィードバック用のIAMロールARN"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "FIFOトピックかどうか"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "コンテンツベースの重複排除を有効にするか（FIFOトピックでのみ有効）"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "SNSトピック暗号化用のKMSキーID"
  type        = string
  default     = null
}

variable "tags" {
  description = "リソースに付与するタグ"
  type        = map(string)
  default     = {}
}

variable "subscriptions" {
  description = "SNSトピックの購読設定"
  type = list(object({
    protocol                        = string
    endpoint                        = string
    confirmation_timeout_in_minutes = optional(number, 1)
    endpoint_auto_confirms          = optional(bool, false)
    raw_message_delivery            = optional(bool, false)
    filter_policy                   = optional(string, null)
    filter_policy_scope             = optional(string, "MessageAttributes")
    delivery_policy                 = optional(string, null)
    redrive_policy                  = optional(string, null)
  }))
  default = []
}
