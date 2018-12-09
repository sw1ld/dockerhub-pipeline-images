FROM  adoptopenjdk/openjdk8:alpine-slim as TCNATIVE
RUN   apk --no-cache add tomcat-native

FROM        adoptopenjdk/openjdk8:alpine-slim
LABEL       maintainer="adorsys GmbH & Co. KG"

EXPOSE      8080

ENV         TZ=Europe/Berlin \
            JAVA_OPTS="-Xmx128m"

WORKDIR     /opt/app-root/src

COPY        --from=TCNATIVE \
              /usr/lib/libapr-1.so.* \
              /usr/lib/libtcnative-1.* \
              /lib/libssl.so.* \
              /lib/libcrypto.so.* \
              /lib/libuuid.so.* \
              /lib/

RUN         apk --no-cache upgrade \
            && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD         root /

ENTRYPOINT  ["/docker-entrypoint.sh"]

CMD         exec java $JAVA_OPTS -jar *.jar

USER        1001
