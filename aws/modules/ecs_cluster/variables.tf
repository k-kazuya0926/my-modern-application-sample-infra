variable "name_prefix" {
  description = "全リソース名のプレフィックス"
  type        = string
}

variable "enable_container_insights" {
  description = "Container Insightsを有効にするかどうか"
  type        = bool
  default     = true
}