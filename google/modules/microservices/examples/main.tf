module "microservice" {
  source = "../"

  gke_project     = data.terraform_remote_state.cluster.outputs.gke_project_id
  service_name    = var.service_name
  environment     = "dev"
  billing_account = var.billing_account
}

data "terraform_remote_state" "cluster" {
  backend = "gcs"

  config = {
    bucket = var.cluster_tfstate_bucket
    prefix = var.cluster_tfstate_prefix
  }
}

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${data.terraform_remote_state.cluster.outputs.gke_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.cluster.outputs.gke_ca_certificate,
  )
}
