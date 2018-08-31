#!/bin/bash

docker run --rm ${DOCKER_IMAGE}:${TAG} /bin/bash -lc '\
    echo "NVM: " && nvm --version && \
    echo "NodeJS: " && node --version && \
    echo "NPM (NodeJS): " && npm --version && \
    echo "YARN: " && yarn --version && \
    echo "Docker: " && docker --version && \
    echo "Java: " && java -version && \
    echo "Maven: " && mvn --version && \
    echo "JMeter: " && jmeter -n --version && \
    echo "Chrome: " && google-chrome-stable --version && \
    echo "Firefox: " && firefox --version'