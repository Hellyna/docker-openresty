image := hellyna/openresty:1.9.3.1-1

default: build

build: Dockerfile
	docker build -t $(image) .
