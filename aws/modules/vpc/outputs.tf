output "vpc_id" {
  description = "VPCのID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPCのCIDRブロック"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "インターネットゲートウェイのID"
  value       = var.enable_internet_gateway ? aws_internet_gateway.main[0].id : null
}

output "public_subnet_ids" {
  description = "パブリックサブネットのID"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "プライベートサブネットのID"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRブロック"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロック"
  value       = aws_subnet.private[*].cidr_block
}

output "availability_zones" {
  description = "サブネットのアベイラビリティゾーン"
  value       = var.availability_zones
}

output "nat_gateway_ids" {
  description = "NATゲートウェイのID"
  value       = aws_nat_gateway.main[*].id
}

output "default_security_group_id" {
  description = "デフォルトセキュリティグループのID"
  value       = aws_security_group.default.id
}