resource "google_sql_database_instance" "main" {
  name = "main"

  project = "${google_project_services.this.project}"

  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"
    disk_type = "PD_HDD"
  }
}

resource "google_sql_database" "this" {
  name      = "mydb"
  instance  = "${google_sql_database_instance.main.name}"
}

resource "google_sql_user" "this" {
  name     = "myuser"

  project = "${google_project_services.this.project}"

  instance = "${google_sql_database_instance.main.name}"
  password = "TODO_CHANGE_ME"
}
