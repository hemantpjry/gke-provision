terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

terraform {
  backend "gcs" {
    bucket = "pollfish-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source      = "./vpc"
  vpc_name    = "demo-vpc"
  subnet_name = "demo-subnet"
  region      = var.region
}

module "artifact_registry" {
  source         = "./artifact_registry"
  region         = var.region
  registry_name  = "demo-repo"
  project_id     = var.project_id
}

module "gke" {
  source       = "./gke"
  cluster_name = "demo-gke-cluster"
  region       = var.region
  network      = module.vpc.vpc_name
  subnet       = module.vpc.subnet_name
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "registry_url" {
  value = module.artifact_registry.registry_url
}
