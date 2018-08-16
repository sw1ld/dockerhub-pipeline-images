FROM centos:7

EXPOSE 8080

ENV TZ=Europe/Berlin \
    JAVA_OPTS="-Xmx128m"

WORKDIR /opt/app-root/src

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum install -y apr java-1.8.0-openjdk-headless && yum clean all

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["java", "${JAVA_OPTS}", "-jar", "/opt/app-root/src/*.jar"]

USER 1001