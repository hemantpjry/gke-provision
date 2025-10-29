variable "region" {
  description = "Region for the Artifact Registry"
  type        = string
}

variable "registry_name" {
  description = "Name of the Artifact Registry repository"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
  default     = ""
}
