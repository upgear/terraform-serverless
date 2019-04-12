package postevent

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"cloud.google.com/go/pubsub"
)

var topic *pubsub.Topic

func init() {
	ctx := context.Background()

	project := os.Getenv("GCP_PROJECT")
	c, err := pubsub.NewClient(ctx, project)
	if err != nil {
		log.Fatal("initializing pubsub client:", err)
	}

	topic = c.Topic(os.Getenv("TOPIC"))
}

type Event struct {
	Type    string
	Message string
}

func Serve(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	var e Event
	if err := json.NewDecoder(r.Body).Decode(&e); err != nil {
		log.Println("decoding payload:", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	data, _ := json.Marshal(e)

	if _, err := topic.Publish(ctx, &pubsub.Message{
		Data: data,
	}).Get(ctx); err != nil {
		log.Println("sending:", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusAccepted)
}
