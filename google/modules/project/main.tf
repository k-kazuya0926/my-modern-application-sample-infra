resource "google_project" "microservice" {
  name       = var.project_name
  project_id = var.project_name
  # 組織を使う場合は有効化する
  #   org_id = var.org_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}

resource "google_project_service" "api_service" {
  for_each = toset(concat(var.default_enabled_services, var.additional_enabled_services))

  project            = google_project.microservice.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_project_iam_member" "service_viewers" {
  for_each = toset(var.service_viewers)

  project = google_project.microservice.project_id
  role    = "roles/viewer"
  member  = "user:${each.key}"
}

resource "google_project_iam_member" "service_admins" {
  for_each = toset(var.service_admins)

  project = google_project.microservice.project_id
  role    = "roles/editor"
  member  = "user:${each.key}"
}
