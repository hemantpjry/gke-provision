resource "google_artifact_registry_repository" "repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.registry_name
  format        = "DOCKER"
  description   = "Docker repository for storing container images"
}

