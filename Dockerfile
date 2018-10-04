FROM golang:1.11.1

# RUN go get -u github.com/golang/dep/cmd/dep

ADD . /go/src/spinnaker.io/demo/k8s-demo

# WORKDIR /go/src/spinnaker.io/demo/k8s-demo
# RUN dep ensure

RUN go install spinnaker.io/demo/k8s-demo

ADD ./content /content

ENTRYPOINT /go/bin/k8s-demo
