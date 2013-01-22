GOPATH=$(realpath $(lastword $(MAKEFILE_LIST))/../go)

.PHONY: goserver spec/runners/servers/go test

spec/runners/servers/go:
	go build -o spec/runners/servers/go scissors-go-server

goserver: spec/runners/servers/go

clean:
	rm -f screenshot*

test: clean goserver
	bundle exec rspec spec
