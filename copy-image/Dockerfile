FROM alpine:latest

ARG VERSION=v2.0.0-rc.1

RUN apk --no-cache add ca-certificates \
    && wget -qO /usr/local/bin/copy-docker-image \
      "https://github.com/jkroepke/copy-docker-image/releases/download/${VERSION}/copy-docker-image_linux_amd64" \
    && chmod +x /usr/local/bin/copy-docker-image
CMD ["/usr/local/bin/copy-docker-image"]