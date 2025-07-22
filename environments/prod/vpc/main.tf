data "aws_region" "current" {}

module "vpc" {
  source = "../../../modules/vpc"

  name_prefix = "${var.github_repository_name}-${local.env}"
  cidr_block  = "10.0.0.0/16"

  availability_zones = [
    "${data.aws_region.current.id}a",
    "${data.aws_region.current.id}c"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  enable_internet_gateway = false
  enable_nat_gateway      = false
}
