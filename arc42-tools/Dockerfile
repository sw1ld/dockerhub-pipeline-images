FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

COPY root /

RUN yum update -y \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && yum install -y openssl java-1.8.0-openjdk-headless ruby fontconfig graphviz jq \
    && yum -y groupinstall "Development Tools" \
    && yum clean all && rm -rf /var/cache/yum \
    && mkdir /usr/local/share/plantuml \
    && curl -s -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2019.5.jar/download --output /usr/local/share/plantuml/plantuml.jar \
    && gem install asciidoctor

USER 1001
