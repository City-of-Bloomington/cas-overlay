include make.conf
# Variables from make.conf:
#
# DOCKER_REPO
IMAGE_NAME=cas
VERSION := $(shell cat gradle.properties | grep "cas.version" | cut -d= -f2)
COMMIT := $(shell git rev-parse --short HEAD)

default: war

war:
	./gradlew build

dockerfile:
	docker build . -t ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT} --build-arg VERSION=${COMMIT}
	docker push ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT}
