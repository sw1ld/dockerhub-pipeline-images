#!/bin/bash

echo "---" > docker-compose.yml
echo "version: '3'" >> docker-compose.yml
echo "services:" >> docker-compose.yml

for FILE in */Dockerfile */*/Dockerfile; do
  BASENAME=${FILE%/Dockerfile}
  echo "  ${BASENAME//[\/-]/_}:" >> docker-compose.yml
  echo "    image: adorsys/${BASENAME/\//:}" >> docker-compose.yml
  echo "    build:" >> docker-compose.yml
  echo "      context: ${BASENAME}" >> docker-compose.yml
done
