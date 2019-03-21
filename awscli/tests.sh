#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" --version
docker run --rm "${DOCKER_IMAGE}:${TAG}" help
