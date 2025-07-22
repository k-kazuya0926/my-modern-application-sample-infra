variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_internet_gateway" {
  description = "Whether to create Internet Gateway"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnets"
  type        = bool
  default     = true
}