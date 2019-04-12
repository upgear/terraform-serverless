# Example Webhook Endpoint (Google Cloud)

This is an example implementation of a webhook implementation using Google Cloud Functions.

## Tech stack

- Terraform
- Go
- Google Cloud Functions/Pubsub/SQL

## Quickstart

```sh
cd ./terraform
terraform init
terraform apply

# Connect to the created google cloud instance (db = mydb):
# CREATE TABLE events (event_id VARCHAR(255), type VARCHAR(255), message VARCHAR(255), PRIMARY KEY (event_id));
# GRANT INSERT ON events TO myuser;

# Send a mock-webhook request:
curl https://us-central1-<your-project>.cloudfunctions.net/postevent -v -d '{"type":"msg", "message":"Howdy"}' -H 'Content-Type: application/json'

# Query DB:
# SELECT * FROM events;
```
