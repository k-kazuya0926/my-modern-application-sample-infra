module "gke_cluster" {
  source = "../../../modules/gke_cluster"

  service_name    = var.service_name
  environment     = local.environment
  billing_account = var.billing_account
}
