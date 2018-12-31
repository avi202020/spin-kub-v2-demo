FROM golang:1.11.4-alpine3.8 as builder
# FROM golang:1.11.1-alpine3.8 as builder
# RUN go get -u github.com/golang/dep/cmd/dep

ADD . /go/src/spinnaker.io/demo/k8s-demo


# RUN dep ensure

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install  -a -installsuffix cgo -ldflags="-w -s" spinnaker.io/demo/k8s-demo
ADD ./content /go/bin/content/

FROM scratch

COPY --from=builder /go/bin/k8s-demo /go/bin/k8s-demo
COPY --from=builder /go/bin/content/ /go/bin/content/

WORKDIR /go/bin/
EXPOSE 8000
ENTRYPOINT ["/go/bin/k8s-demo"]
