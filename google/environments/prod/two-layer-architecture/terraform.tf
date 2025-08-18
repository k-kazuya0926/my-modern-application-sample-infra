terraform {
  required_version = "1.12.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.48.0"
    }
  }

  backend "gcs" {
    # 他の項目は terraform init -backend-config=../backend.hcl により設定
    prefix = "prod/two-layer-architecture"
  }
}

provider "google" {
  project = var.project_id
  region  = "asia-northeast1"
}
