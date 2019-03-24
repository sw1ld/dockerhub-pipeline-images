FROM adoptopenjdk/openjdk8:slim
LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

WORKDIR /opt/app-root/src

RUN rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update && apt-get upgrade -y \
    && apt-get autoremove -y --purge  \
    && apt-get install -y --no-install-recommends libtcnative-1 \
    && rm -rf /var/lib/apt/lists/*

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
