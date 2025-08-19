module "gke_cluster" {
  source = "../../gke_cluster"

  service_name    = var.service_name
  billing_account = var.billing_account
  service_viewers = []
  environment     = "prod"
}
