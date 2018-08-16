#!/bin/bash

docker run --rm ${DOCKER_IMAGE}:${TAG} docker --version
docker run --rm ${DOCKER_IMAGE}:${TAG} ansible --version
docker run --rm ${DOCKER_IMAGE}:${TAG} helm version
docker run --rm ${DOCKER_IMAGE}:${TAG} helm diff version
docker run --rm ${DOCKER_IMAGE}:${TAG} helm diff version
docker run --rm ${DOCKER_IMAGE}:${TAG} copy-docker-image --help