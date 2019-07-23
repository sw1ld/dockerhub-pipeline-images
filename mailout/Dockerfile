FROM adorsys/ci-build AS BUILD
COPY . .
RUN bash -c "nvm use && npm ci"

FROM adorsys/node:10

ENV \
  HARAKA_LOG_LEVEL=warn \
  HARAKA_LOG_TIMESTAMPS=true \
  HARAKA_HOSTNAME=mailout.local \
  HARAKA_RELAY=all \
  HARAKA_NODES=0 \
  HARAKA_TLS_CA_BUNDLE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
  HARAKA_TLS_LISTEN_KEY=/var/run/secrets/serving-cert-secret/tls.key \
  HARAKA_TLS_LISTEN_CERT=/var/run/secrets/serving-cert-secret/tls.crt \
  HARAKA_AUTH_RELAY_USER=relay \
  HARAKA_RELAY_PORT=25 \
  HARAKA_RELAY_AUTH_TYPE=plain

VOLUME /var/spool/haraka

USER 0

COPY --from=BUILD /opt/app-root/src/node_modules/ /opt/app-root/node_modules/
COPY root /

RUN mkdir -p /opt/app-root/queue /opt/app-root/config \
    && chgrp 0   -R /opt/app-root/queue /opt/app-root/config \
    && chmod g=u -R /opt/app-root/queue /opt/app-root/config \
    && setcap cap_net_bind_service=+ep "$(command -v node)"

USER 1001

HEALTHCHECK CMD /healthcheck.sh || exit 1
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["npx", "--no-install", "haraka", "-c", "."]
