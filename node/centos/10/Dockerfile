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

# discard npm update warnings
ENV NO_UPDATE_NOTIFIER=1\
    TZ=Europe/Berlin \
    ENABLE_AUTO_NODE_MEMORY_LIMIT=true \
    NODE_MEMORY_LIMIT_PERCENT=80

WORKDIR /opt/app-root

RUN yum update -y && yum clean all && rm -rf /var/cache/yum && \
    echo -e '[nodesource]\nname=nodesource\nbaseurl=https://rpm.nodesource.com/pub_10.x/el/7/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL' > /etc/yum.repos.d/nodesource.repo && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum install -y openssl nodejs && \
    yum clean all -y && \
    npm install -g npm yarn && \
    npm cache clear --force && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

COPY root /

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001
