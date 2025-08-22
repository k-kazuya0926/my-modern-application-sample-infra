output "gke_project_id" {
  description = "The ID of the project"
  value       = module.gke_cluster.gke_project_id
}

output "gke_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = module.gke_cluster.gke_endpoint
  sensitive   = true
}

output "gke_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = module.gke_cluster.gke_ca_certificate
  sensitive   = true
}
