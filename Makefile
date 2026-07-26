APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=ogoncharenko32
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #darwin windows 
TARGETARCH=arm64 #amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ogoncharenko32/kbot/cmd.appVersion=${VERSION}

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot