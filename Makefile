include make.conf
# Variables from make.conf:
#
# DOCKER_REPO=https://docker.example.org/somewhere
IMAGE_NAME=cas
VERSION := $(shell cat gradle.properties | grep "cas.version" | cut -d= -f2)
COMMIT := $(shell git rev-parse --short HEAD)

default: war

compile:
	sassc -m -t compact src/main/resources/static/css/cob.scss src/main/resources/static/css/cas-${VERSION}.css
	echo "cas.standard.css.file=/css/cas-${VERSION}.css" > src/main/resources/cas-theme-default.properties

war: compile
	./gradlew clean build

dockerfile: compile
	docker build . -t ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT} --build-arg VERSION=${COMMIT}
	docker push ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT}
