package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"strconv"

	"github.com/prometheus/client_golang/prometheus"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func index(w http.ResponseWriter, r *http.Request) {
	if rand.Int63n(100) < errRate {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	// fmt.Printf("Handling %+v\n", r)
	bs, err := ioutil.ReadFile("./content/index.html")

	if err != nil {
		fmt.Printf("Couldn't read index.html: %v", err)
		os.Exit(1)
	}

	io.WriteString(w, string(bs[:]))
}

var errRate int64 = 0

func main() {
	failRate := os.Getenv("FAIL_RATE")
	if failRate != "" {
		var err error

		errRate, err = strconv.ParseInt(failRate, 10, 64)
		if err != nil {
			fmt.Println(err)
		}
	}
	http.HandleFunc("/", prometheus.InstrumentHandlerFunc("index", index))
	http.Handle("/metrics", promhttp.Handler())
	port := ":8000"
	fmt.Printf("Starting to service on port %s\n", port)
	http.ListenAndServe(port, nil)
}
