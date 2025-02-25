export GOBIN := $(PWD)/bin
export PATH := $(GOBIN):$(PATH)
export GOFLAGS := -mod=mod

./bin:
	mkdir ./bin

./bin/gowrap: ./bin
	go install ./cmd/gowrap

./bin/golangci-lint: ./bin
	go install -modfile tools/go.mod github.com/golangci/golangci-lint/cmd/golangci-lint

./bin/goreleaser:
	go install -modfile tools/go.mod github.com/goreleaser/goreleaser

lint: ./bin/golangci-lint
	./bin/golangci-lint run --enable=goimports --disable=unused --exclude=S1023,"Error return value" ./...

test:
	 go test -race ./...

generate: ./bin/gowrap
	go generate ./...

all: ./bin/gowrap generate lint test

release: ./bin/goreleaser
	goreleaser release

build: ./bin/goreleaser
	goreleaser build --snapshot --rm-dist

clean:
	rm -rf ./bin
