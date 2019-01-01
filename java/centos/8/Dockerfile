FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

WORKDIR /opt/app-root/src

RUN yum update -y && yum clean all && rm -rf /var/cache/yum \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && yum install epel-release -y && yum install -y java-1.8.0-openjdk-headless tomcat-native && yum clean all \
    && chmod g=u /etc/passwd

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD exec java $JAVA_OPTS -jar *.jar

USER 1001
