include make.conf
# Variables from make.conf:
#
# DOCKER_REPO


DOCKER := $(shell command -v docker 2> /dev/null)


IMAGE_NAME=cas
IMAGE_TAG := $(shell cat gradle.properties | grep "cas.version" | cut -d= -f2)

dependencies:
ifndef DOCKER
	$(error "Docker is not installed")
endif


default: build

build: dependencies
	docker build -t ${DOCKER_REPO}/cob/${IMAGE_NAME}:${IMAGE_TAG} .

push:
	docker push ${DOCKER_REPO}/cob/${IMAGE_NAME}:${IMAGE_TAG}
