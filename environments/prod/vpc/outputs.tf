output "vpc_id" {
  description = "VPCのID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPCのCIDRブロック"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnet_ids" {
  description = "プライベートサブネットのID"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "パブリックサブネットのID"
  value       = module.vpc.public_subnet_ids
}

output "internet_gateway_id" {
  description = "インターネットゲートウェイのID"
  value       = module.vpc.internet_gateway_id
}

output "default_security_group_id" {
  description = "デフォルトセキュリティグループのID"
  value       = module.vpc.default_security_group_id
}

output "availability_zones" {
  description = "サブネットのアベイラビリティゾーン"
  value       = module.vpc.availability_zones
}