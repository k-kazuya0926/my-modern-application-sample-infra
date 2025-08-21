module "project" {
  source = "../project"

  project_name    = local.service_name_with_env
  billing_account = var.billing_account
}

locals {
  service_name_with_env = "${var.service_name}-${var.environment}"
}

resource "google_container_cluster" "primary" {
  name     = "primary"
  project  = module.project.project_id
  location = var.region

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  workload_identity_config {
    workload_pool = "${module.project.project_id}.svc.id.goog"
  }

  initial_node_count       = 1
  remove_default_node_pool = true
  deletion_protection      = false
}

resource "google_container_node_pool" "primary" {
  name     = "primary"
  project  = module.project.project_id
  location = var.region

  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
