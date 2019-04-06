FROM adoptopenjdk/openjdk8:alpine-slim
LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

WORKDIR /opt/app-root/src

RUN apk --no-cache upgrade \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && chmod g=u /etc/passwd

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
