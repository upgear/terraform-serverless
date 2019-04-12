package storeevent

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"os"

	// Import the Postgres SQL driver.
	"github.com/google/uuid"
	_ "github.com/lib/pq"
)

var (
	db *sql.DB

	connectionName = os.Getenv("POSTGRES_INSTANCE_CONNECTION_NAME")
	dbName         = os.Getenv("POSTGRES_DBNAME")
	dbUser         = os.Getenv("POSTGRES_USER")
	dbPassword     = os.Getenv("POSTGRES_PASSWORD")
)

func init() {
	dsn := fmt.Sprintf("dbname=%s user=%s password=%s host=/cloudsql/%s", dbName, dbUser, dbPassword, connectionName)
	var err error
	db, err = sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("Could not open db: %v", err)
	}

	// Only allow 1 connection to the database to avoid overloading it.
	db.SetMaxIdleConns(1)
	db.SetMaxOpenConns(1)
}

// PubSubMessage is the payload of a Pub/Sub event. Please refer to the docs for
// additional information regarding Pub/Sub events.
type PubSubMessage struct {
	Data []byte `json:"data"`
}

type Event struct {
	Type    string
	Message string
}

func Serve(ctx context.Context, m PubSubMessage) error {
	var e Event
	if err := json.Unmarshal(m.Data, &e); err != nil {
		log.Println("unable to unmarshal event:", err)
		return nil
	}

	_, err := db.ExecContext(ctx, `
		INSERT INTO events (event_id, type, message)
		VALUES ($1, $2, $3);`,
		uuid.New().String(), e.Type, e.Message)
	if err != nil {
		log.Println("inserting event:", err)
		return err
	}

	return nil
}
