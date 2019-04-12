locals {
  project_id      = "${var.namespace}-${random_id.project.hex}"
}

provider "google" {
#  credentials = "${file("account.json")}"
  project = "${local.project_id}"
  region  = "us-central1"
  version = "2.0.0"
}

provider "google-beta" {
#  credentials = "${file("account.json")}"
  project = "${local.project_id}"
  region  = "us-central1"
  version = "2.0.0"
}

resource "random_id" "project" {
  byte_length = 4
}

resource "google_project" "this" {
  name = "My Project"
  project_id = "${local.project_id}"
  org_id = "${var.organization_id}"
  billing_account = "${var.billing_account}"
}

resource "google_project_services" "this" {
  project = "${google_project.this.project_id}"
  services = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "cloudfunctions.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-component.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "logging.googleapis.com",
    "storage-api.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}
