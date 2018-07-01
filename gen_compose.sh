#!/bin/bash

echo "---" > docker-compose.yml
echo "version: '3'" >> docker-compose.yml
echo "services:" >> docker-compose.yml

for file in */Dockerfile */*/Dockerfile; do
  echo "  ${file//[\/-]/_}:" >> docker-compose.yml
  echo "    build:" >> docker-compose.yml
  echo "      context: ${file%Dockerfile}" >> docker-compose.yml
  echo "    deploy:" >> docker-compose.yml
  echo "      replicas: 0" >> docker-compose.yml
done
