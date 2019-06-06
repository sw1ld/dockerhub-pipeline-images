#!/bin/bash

set -euo pipefail

docker run --rm "${DOCKER_IMAGE}:${TAG}" npx haraka -v
