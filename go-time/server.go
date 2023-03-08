package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"
)

func GetCurrentTimeAsJSON(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()
	timeObj := struct {
		Time time.Time `json:"time"`
		Lang string    `json:"lang"`
	}{
		Time: currentTime,
		Lang: "Go",
	}
	timeJSON, err := json.Marshal(timeObj)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(timeJSON)
}

func main() {
	log.Println("Starting go-time server ...")
	http.HandleFunc("/", GetCurrentTimeAsJSON)
	log.Fatal(http.ListenAndServe(":80", nil))
}
