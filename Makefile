include make.conf
# Variables from make.conf:
#
# DOCKER_REPO
# DEPLOY_NAME
DOCKER := $(shell command -v docker 2> /dev/null)

IMAGE_NAME=cas
VERSION := $(shell cat gradle.properties | grep "cas.version" | cut -d= -f2)
COMMIT := $(shell git rev-parse --short HEAD)

default: build

dependencies:
ifndef DOCKER
	$(error "Docker is not installed")
endif

build: dependencies
	docker build . -t ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT} --build-arg VERSION=${COMMIT} --build-arg DEPLOY_NAME=${DEPLOY_NAME}

push:
	docker push ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT}
