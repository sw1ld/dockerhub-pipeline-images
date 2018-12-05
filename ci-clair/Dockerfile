FROM arminc/clair-local-scan:v2.0.6

ARG VERSION_CLAIR_SCANNER=v8

RUN apk add --no-cache docker \
  && wget -q -O /usr/bin/clair-scanner https://github.com/arminc/clair-scanner/releases/download/${VERSION_CLAIR_SCANNER}/clair-scanner_linux_amd64 \
  && chmod +x /usr/bin/clair-scanner

ADD root /

ENTRYPOINT [""]
