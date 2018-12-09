#!/bin/sh

docker run --rm ${DOCKER_IMAGE}:${TAG} node --version
docker run --rm ${DOCKER_IMAGE}:${TAG} npm --version
