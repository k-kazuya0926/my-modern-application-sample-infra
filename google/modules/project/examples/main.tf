module "project" {
  source = "../../project"

  project_name    = var.project_name
  billing_account = var.billing_account
}
