FROM registry.access.redhat.com/ubi8/ubi AS TZDATA

FROM registry.access.redhat.com/ubi8/ubi-minimal AS TCNATIVE

RUN microdnf install -y apr-devel openssl-devel java-11-openjdk-devel tar gzip gcc make redhat-rpm-config

RUN set -x \
    # https://github.com/infosiftr/tomcat/blob/5f1abae99c0b1ebbd4f020bc4b5696619d948cfd/7/jre8-alpine/Dockerfile
    && nativeBuildDir="$(mktemp -d)" \
    && nativeVersion=$(curl -sSf "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/" | sed -nE 's/.*<a href="([0-9]+\.[0-9]+.[0-9]+)\/">.*/\1/p' | tail -n1) \
    && curl -sSf "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/${nativeVersion}/source/tomcat-native-${nativeVersion}-src.tar.gz" | tar -zxv -C "$nativeBuildDir" --strip-components=1 \
    && export CATALINA_HOME="$PWD" \
    && cd "$nativeBuildDir/native" \
    && ./configure --with-apr=/usr/bin/apr-1-config \
              --with-java-home=/usr/lib/jvm/java-openjdk  \
              --with-ssl=yes \
              --prefix=/usr \
    && make && make install

FROM registry.access.redhat.com/ubi8/ubi-minimal

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

WORKDIR /opt/app-root/src

# https://bugzilla.redhat.com/show_bug.cgi?id=1611117
COPY --from=TZDATA /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
COPY --from=TZDATA /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/Europe/Berlin

COPY --from=TCNATIVE /usr/lib/libtcnative*so /usr/lib/

RUN microdnf update -y && microdnf clean all && rm -rf /var/cache/yum \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && microdnf install -y openssl java-11-openjdk-headless apr && microdnf clean all \
    && chmod g=u /etc/passwd

COPY root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
