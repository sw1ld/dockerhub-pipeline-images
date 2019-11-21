FROM python:alpine

LABEL maintainer="adorsys GmbH & Co. KG" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

ENV PAGER="more"
ENV HOME=/tmp

RUN apk add --no-cache jq zip groff curl bash && \
    pip --disable-pip-version-check install -U --compile --no-cache-dir awscli s3cmd

ENTRYPOINT ["/usr/local/bin/aws"]
CMD ["--version"]
