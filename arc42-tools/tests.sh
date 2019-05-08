#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" plantuml -version
docker run --rm "${DOCKER_IMAGE}:${TAG}" asciidoctor -v
