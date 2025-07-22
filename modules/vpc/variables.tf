variable "name_prefix" {
  description = "全リソース名のプレフィックス"
  type        = string
}

variable "cidr_block" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "アベイラビリティゾーンのリスト"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロック"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロック"
  type        = list(string)
}

variable "enable_internet_gateway" {
  description = "インターネットゲートウェイを作成するかどうか"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "プライベートサブネット用のNATゲートウェイを作成するかどうか"
  type        = bool
  default     = true
}