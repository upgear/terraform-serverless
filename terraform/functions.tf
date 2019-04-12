resource "google_storage_bucket" "functions" {
  project = "${google_project_services.this.project}"
  name = "${google_project.this.project_id}-functions"
}

module "postevent_function" {
  source = "./httpfunc"
  name   = "postevent"

  env = {
    "TOPIC" = "${google_pubsub_topic.events.name}"
  }

  project = "${google_project_services.this.project}"
  bucket  = "${google_storage_bucket.functions.name}"
}

module "storeevent_function" {
  source = "./pubsubfunc"
  name   = "storeevent"

  env = {
    "POSTGRES_INSTANCE_CONNECTION_NAME" = "${google_sql_database_instance.main.connection_name}"
    "POSTGRES_DBNAME"   = "${google_sql_database.this.name}"
    "POSTGRES_USER"     = "${google_sql_user.this.name}"
    "POSTGRES_PASSWORD" = "${google_sql_user.this.password}"
  }

  project = "${google_project_services.this.project}"
  bucket  = "${google_storage_bucket.functions.name}"

  topic = "${google_pubsub_topic.events.name}"
}
