variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "Region where the cluster will be created"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnet" {
  description = "Subnet name"
  type        = string
}
