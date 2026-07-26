APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=ogoncharenko32
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #darwin windows 
TARGETARCH=arm64 #amd64
TELE_TOKEN=$(shell read -sp "TELE_TOKEN: " TELE_TOKEN)

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

run:
		@read -s -p "Введіть TELE_TOKEN: " TELE_TOKEN; \
		echo; \
		[-n "$$TELE_TOKEN" ] || { echo "Токен не вказано"; exit 1; }; \
		docker run --rm \
		-e TELE_TOKEN="$$TELE_TOKEN" \
		-it ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot && docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}