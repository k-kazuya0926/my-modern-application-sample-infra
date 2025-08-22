module "microservice" {
  source = "../../../../modules/microservices"

  gke_project     = data.terraform_remote_state.cluster.outputs.gke_project_id
  service_name    = var.service_name
  environment     = local.environment
  billing_account = var.billing_account
}
