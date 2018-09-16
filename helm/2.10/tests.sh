#!/bin/bash

docker run --rm ${DOCKER_IMAGE}:${TAG} docker --version
docker run --rm ${DOCKER_IMAGE}:${TAG} ansible --version
docker run --rm ${DOCKER_IMAGE}:${TAG} helm version -c
docker run --rm -e HELM_HOST=localhost ${DOCKER_IMAGE}:${TAG} helm diff -h
docker run --rm ${DOCKER_IMAGE}:${TAG} helm push -h
docker run --rm ${DOCKER_IMAGE}:${TAG} copy-docker-image --help
