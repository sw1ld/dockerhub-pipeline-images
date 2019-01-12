FROM python:alpine

LABEL maintainer="adorsys GmbH & Co. KG"

ENV PAGER="more"

RUN apk add --no-cache jq zip groff && \
    pip --disable-pip-version-check install -U --compile --no-cache-dir awscli

# Expose volume for adding credentials
VOLUME ["~/.aws"]

ENTRYPOINT ["/usr/local/bin/aws"]
CMD ["--version"]
