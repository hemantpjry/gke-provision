# ☁️ GKE Infrastructure Provisioning with Terraform

This project provisions a **Google Kubernetes Engine (GKE)** cluster, a **VPC network**, and an **Artifact Registry** using **Terraform** in a modular structure.  
It follows infrastructure-as-code best practices, enabling secure, repeatable, and scalable infrastructure deployment.

---

## 🚀 Overview

This Terraform configuration:
- Creates a **custom VPC** and **subnet**.
- Deploys a **GKE cluster** with a dedicated node pool.
- Sets up an **Artifact Registry** for Docker images.
- Manages Terraform state remotely in a **Google Cloud Storage (GCS)** bucket.
- Uses a **dedicated service account (`terraform-sa`)** with minimal IAM roles.

---

## 🧱 Project Structure

```bash
terraform-gcp/
├── artifact_registry/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── gke/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── vpc/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── terraform.tfvars
└── .terraform.lock.hcl

🧩 Module Responsibilities
Module	Description
vpc	Creates a custom VPC and subnet.
artifact_registry	Creates a regional Artifact Registry for Docker images.
gke	Provisions a GKE cluster and node pool using the created VPC.

2️⃣ Authenticate with Google Cloud
gcloud auth login
gcloud config set project <YOUR_PROJECT_ID>
🔐 Service Account Setup (terraform-sa)
A dedicated service account named terraform-sa is used to authenticate Terraform with least-privilege permissions.

Create the Service Account
gcloud iam service-accounts create terraform-sa \
  --display-name "Terraform Service Account"

Assign Required Roles
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/compute.networkAdmin"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.admin"

Generate and Activate Key
gcloud iam service-accounts keys create key.json \
  --iam-account=terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=key.json

☁️ Remote State Management (GCS Backend)
Terraform uses Google Cloud Storage (GCS) as a backend to store state securely.

Example (main.tf):
terraform {
  backend "gcs" {
    bucket = "pollfish-bucket"
    prefix = "terraform/state"
  }
}
Create the backend bucket if it doesn’t exist:

gsutil mb -p <PROJECT_ID> -l us-central1 gs://pollfish-bucket/

📦 Variables and Configuration
terraform.tfvars
project_id = "pollfish-assignment-1-476108"
region     = "us-central1"
Variable	Description	Default
project_id	GCP Project ID	—
region	Deployment region	us-central1

🧩 Module Outputs
Module	Output	Example Value
vpc	vpc_name, subnet_name	demo-vpc, demo-subnet
artifact_registry	registry_url	asia-south1-docker.pkg.dev/pollfish-assignment-1-476108/demo-repo
gke	cluster_name	demo-gke-cluster

🏗️ Terraform Workflow
Initialize
terraform init

Validate
terraform validate

Plan
terraform plan

Apply
terraform apply -auto-approve

☸️ Connect to GKE
After successful apply:

gcloud container clusters get-credentials demo-gke-cluster \
  --region us-central1 \
  --project pollfish-assignment-1-476108

kubectl get nodes
Expected output:
NAME                                      STATUS   ROLES    AGE   VERSION
gke-demo-gke-cluster-node-pool-xyz123     Ready    <none>   2m    v1.30.4-gke.1302000

🧹 Cleanup
To destroy all resources:
terraform destroy -auto-approve

🧠 Key Highlights
✅ Modular Terraform architecture (VPC, GKE, Artifact Registry)
✅ Remote state management via GCS bucket
✅ Least-privilege service account authentication
✅ Simplified cluster + registry outputs for CI/CD integration
✅ Reusable and version-controlled infrastructure

🧭 Architecture Overview
text

                   ┌───────────────────────────────┐
                   │        Terraform CLI           │
                   └──────────────┬────────────────┘
                                  │
                                  ▼
        ┌────────────────────────────────────────────────┐
        │           Google Cloud Platform (GCP)           │
        │                                                  │
        │  ┌───────────────┐     ┌────────────────┐        │
        │  │   VPC (demo)  │────▶│ Subnet (demo) │        │
        │  └───────────────┘     └────────────────┘        │
        │          │                                       │
        │          ▼                                       │
        │  ┌───────────────────────────┐                   │
        │  │     GKE Cluster           │                   │
        │  │ (demo-gke-cluster)        │                   │
        │  └───────────────────────────┘                   │
        │          │                                       │
        │          ▼                                       │
        │  ┌───────────────────────────┐                   │
        │  │  Artifact Registry (demo) │                   │
        │  └───────────────────────────┘                   │
        └──────────────────────────────────────────────────┘
👨‍💻 Author
Hemanth Poojary
📧 hemanthpoojary27@gmail.com
