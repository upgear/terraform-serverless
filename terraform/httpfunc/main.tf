locals {
  gcs_filename = "${var.name}.${lower(replace(base64encode(data.archive_file.source.output_md5), "=", ""))}.zip"
}

data "archive_file" "source" {
    type        = "zip"
    source_dir  = "../functions/${var.name}"
    output_path = "../build/functions/${var.name}.zip"
}

resource "google_storage_bucket_object" "source" {
  name   = "${local.gcs_filename}"
  bucket = "${var.bucket}"
  source = "${data.archive_file.source.output_path}"
}

resource "google_cloudfunctions_function" "this" {
  provider = "google-beta"

  name                  = "${var.name}"
  description           = "My Function"
  available_memory_mb   = 128
  source_archive_bucket = "${var.bucket}"
  source_archive_object = "${google_storage_bucket_object.source.name}"
  runtime               = "go111"
  timeout               = 60
  entry_point           = "Serve"
  trigger_http          = true
  labels = {
    my-label = "my-label-value"
  }

  environment_variables = "${var.env}"
}
