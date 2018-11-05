#!/bin/bash

docker run --rm ${DOCKER_IMAGE}:${TAG} plantuml -v
docker run --rm ${DOCKER_IMAGE}:${TAG} asciidoctor -v
