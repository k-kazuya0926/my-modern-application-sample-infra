terraform {
  required_version = "1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }

  backend "s3" {
    # 他の項目は terraform init -backend-config=../backend.hcl により設定
    key = "prod/vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
