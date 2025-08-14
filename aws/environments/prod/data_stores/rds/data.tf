data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "${var.github_repository_name}-${local.env}-tfstate"
    key    = "${local.env}/vpc/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
