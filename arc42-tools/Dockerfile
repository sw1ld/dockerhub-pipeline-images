FROM ubuntu:18.04

LABEL maintainer="adorsys GmbH & Co. KG" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m" \
    DEBIAN_FRONTEND=noninteractive

COPY root /

RUN apt-get update && apt-get upgrade -y && apt-get clean all \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get install -y openjdk-11-jdk-headless curl graphviz ruby fontconfig graphviz jq && apt-get clean all \
    && mkdir /usr/local/share/plantuml \
    && curl -s -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2019.7.jar/download --output /usr/local/share/plantuml/plantuml.jar \
    && gem install --no-document asciidoctor \
    && apt-get remove --purge --auto-remove -y curl && apt-get clean all

USER 1001
