FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ARG JAVA_11_MINOR=28

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m" \
    PATH="/usr/local/share/jdk-11/bin/:$PATH"

WORKDIR /opt/app-root/src

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    curl -sSf https://download.java.net/java/GA/jdk11/${JAVA_11_MINOR}/GPL/openjdk-11+${JAVA_11_MINOR}_linux-x64_bin.tar.gz | tar xz -C /usr/local/share/

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
