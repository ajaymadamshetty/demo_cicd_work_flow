terraform {
  required_version = "~> 0.14.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.69.1"
    }
  }
}
terraform {
  backend "gcs" {
    bucket = "ajay-pipeline" # GCS bucket name to store terraform tfstate
    prefix = "cicd-demo/dev/CloudRunService"               # Prefix name should be unique for each Terraform project having same remote state bucket.
  }
}
provider "google" {
  project = "ajayjenkins"
}
resource "google_cloud_run_v2_service" "default" {
  name     = "demo-dev-cloudrun-service"
  location = "us-central1"
  ingress = "INGRESS_TRAFFIC_ALL"
  template {
    containers {
      image = "us-central1-docker.pkg.dev/ajayjenkins/ajay-pipeline/pythondemoimage:latest"       
      resources {
        limits = {
          cpu    = "2"
          memory = "1024Mi"
        }
      }
      ports {
        container_port = 9090  # Specify the port your application listens on
      }
    }
  }
}

output "service_name" {
  value       = google_cloud_run_v2_service.default.name
  description = "Name of the created service"
}

output "location" {
  value       = google_cloud_run_v2_service.default.location
  description = "Location in which the Cloud Run service was created"
}

