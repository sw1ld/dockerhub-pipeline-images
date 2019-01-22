FROM adoptopenjdk/openjdk8:alpine-slim
LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

WORKDIR /opt/app-root/src

RUN apk --no-cache upgrade \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && chmod g=u /etc/passwd \
    && set -x \
    # https://github.com/infosiftr/tomcat/blob/5f1abae99c0b1ebbd4f020bc4b5696619d948cfd/7/jre8-alpine/Dockerfile
    && nativeBuildDir="$(mktemp -d)" \
    && nativeVersion=$(wget -q "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/" -O- | sed -nr 's/.*<a href="(\d+\.\d+.\d+)\/">.*/\1/p') \
    && wget -O "$nativeBuildDir/tomcat-native.tar.gz" "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/${nativeVersion}/source/tomcat-native-${nativeVersion}-src.tar.gz" \
    && tar -xvf "$nativeBuildDir/tomcat-native.tar.gz" -C "$nativeBuildDir" --strip-components=1 \
    && apk add --no-cache --virtual .native-build-deps \
      apr-dev \
      gcc \
      libc-dev \
      make \
      openssl-dev \
    && ( \
      export CATALINA_HOME="$PWD" \
      && cd "$nativeBuildDir/native" \
      && ./configure \
        --libdir="/usr/lib" \
        --prefix="/usr" \
        --with-apr="$(which apr-1-config)" \
        --with-java-home="$JAVA_HOME" \
        --with-ssl=yes \
      && make -j$(getconf _NPROCESSORS_ONLN) \
      && make install \
    ) \
    && runDeps="$( \
      scanelf --needed --nobanner "/usr/lib/libtcnative-1.so" \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u \
    )" \
    # Symlinks to fix issues with error "libc.musl-x86_64.so.1: cannot open shared object file: No such file or directory"
    && ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1 \
    && ldd /usr/lib/libtcnative-1.so | awk '$3 ~ /^\/lib/ {print $3}' | xargs -i ln -s {} /usr{} \
    && apk add --no-cache --virtual .tomcat-native-rundeps $runDeps \
    && apk del .native-build-deps \
    && rm -rf "$nativeBuildDir" "/usr/lib/pkgconfig" "/usr/lib/libtcnative-1.a" "/usr/lib/libtcnative-1.la"

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
