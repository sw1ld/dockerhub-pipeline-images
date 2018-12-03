FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m" \
    PATH="/usr/local/share/jdk-11/bin/:$PATH"

WORKDIR /opt/app-root/src

RUN yum update -y && yum clean all && rm -rf /var/cache/yum \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && curl -sSf https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz | tar xz --exclude='src.zip' -C /usr/local/share/

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
