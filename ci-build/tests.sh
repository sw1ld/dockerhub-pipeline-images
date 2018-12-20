#!/bin/bash

docker run --rm ${DOCKER_IMAGE}:${TAG} bash --version

docker run --rm ${DOCKER_IMAGE}:${TAG} docker --version
docker run --rm ${DOCKER_IMAGE}:${TAG} java -version
docker run --rm ${DOCKER_IMAGE}:${TAG} mvn --version
docker run --rm ${DOCKER_IMAGE}:${TAG} jmeter -n --version
docker run --rm ${DOCKER_IMAGE}:${TAG} google-chrome-stable --version
docker run --rm ${DOCKER_IMAGE}:${TAG} firefox --version
docker run --rm ${DOCKER_IMAGE}:${TAG} skopeo -v

docker run --rm ${DOCKER_IMAGE}:${TAG} ip -V

# Default should be java 8
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'java -version 2>&1 | grep -q "build 1\.8"'

docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'jabba use system@1.8 && java -version 2>&1 | grep -q "build 1\.8"'
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'jabba use system@1.11 && java -version 2>&1 | grep -q "build 11"'

docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 8 node --version | grep -q "node v8"'
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 10 node --version | grep -q "node v10"'

docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 8 node --version'
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 10 node --version'

docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 8 npm --version'
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 10 npm --version'

docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 8 yarn --version'
docker run --rm --entrypoint=/bin/bash ${DOCKER_IMAGE}:${TAG} -c 'nvm exec 10 yarn --version'
