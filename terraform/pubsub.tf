resource "google_pubsub_topic" "events" {
  name = "events"
  project = "${google_project.this.project_id}"
}
