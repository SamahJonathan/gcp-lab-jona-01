# Configuracion de la propia herramienta, no de GCP.
# Apuntes: docs/apuntes-etapa-01-terraform-apis.md
terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"

    }
  }
}

# Valores por defecto para todos los recursos del modulo.
# Sin credenciales: el provider lee las Application Default Credentials.
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
locals {
  apis = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "container.googleapis.com",
    "run.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "storage.googleapis.com",
    "sqladmin.googleapis.com",
    "bigquery.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.apis)

  project = var.project_id
  service = each.value

  disable_on_destroy         = false
  disable_dependent_services = false
}
