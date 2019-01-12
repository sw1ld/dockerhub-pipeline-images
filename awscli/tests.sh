#!/bin/sh

docker run --rm "${DOCKER_IMAGE}:${TAG}" --version
docker run --rm "${DOCKER_IMAGE}:${TAG}" help
