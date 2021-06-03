include make.conf
# Variables from make.conf:
#
# DOCKER_REPO=https://docker.example.org/somewhere
IMAGE_NAME=cas
VERSION := $(shell cat gradle.properties | grep "cas.version" | cut -d= -f2)
COMMIT := $(shell git rev-parse --short HEAD)

default: theme

clean:
	rm src/main/resources/static/css/cas-*.css
	rm src/main/resources/cas-theme-default.properties
	./gradlew clean

theme:
	sassc -m -t compact src/main/resources/static/css/cob.scss src/main/resources/static/css/cas-${VERSION}.css
	echo "cas.standard.css.file=/css/cas-${VERSION}.css" > src/main/resources/cas-theme-default.properties

war: theme
	./gradlew build

dockerfile: theme
	docker build . -t ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT} --build-arg VERSION=${COMMIT}
	docker push ${DOCKER_REPO}/${IMAGE_NAME}:${VERSION}-${COMMIT}
