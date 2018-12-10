FROM node:8-alpine

LABEL maintainer="adorsys GmbH & Co. KG"

EXPOSE 8080

# discard npm update warnings
ENV NO_UPDATE_NOTIFIER=1 \
    TZ=Europe/Berlin

WORKDIR /opt/app-root

RUN apk --no-cache upgrade && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    npm install -g npm yarn && \
    npm cache clear --force && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001
