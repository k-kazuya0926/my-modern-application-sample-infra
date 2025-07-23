data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "dynamodb" {
  backend = "s3"
  config = {
    bucket = "${var.github_repository_name}-${local.env}-tfstate"
    key    = "${local.env}/data_stores/dynamodb/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
