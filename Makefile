.PHONY: build push

IMAGE = index.docker.io/kublr/spin-kub-v2-demo
TAG = v1.0-manual-061

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker -- push $(IMAGE):$(TAG)
