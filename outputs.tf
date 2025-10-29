output "vpc_name" {
  value = module.vpc.vpc_name
}

output "subnet_name" {
  value = module.vpc.subnet_name
}

output "artifact_registry" {
  value = module.artifact_registry.registry_url
}

output "gke_cluster" {
  value = module.gke.cluster_name
}
