#!/bin/sh

docker run --rm "${DOCKER_IMAGE}:${TAG}" java -version

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
