FROM adorsys/ci-build AS BUILD
COPY . .
RUN bash -c "nvm use && npm ci"

FROM adorsys/node:10

ENV HARAKA_LOG_LEVEL=warn
ENV HARAKA_LOG_TIMESTAMPS=true
ENV HARAKA_HOSTNAME=mailout.local
ENV HARAKA_RELAY=all
ENV HARAKA_NODES=0
ENV HARAKA_TLS_CA_BUNDLE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
ENV HARAKA_TLS_LISTEN_KEY=/var/run/secrets/serving-cert-secret/tls.key
ENV HARAKA_TLS_LISTEN_CERT=/var/run/secrets/serving-cert-secret/tls.crt
ENV HARAKA_AUTH_RELAY_USER=relay
ENV HARAKA_RELAY_PORT=25
ENV HARAKA_RELAY_AUTH_TYPE=plain

VOLUME /var/spool/haraka

USER 0

COPY --from=BUILD /opt/app-root/src/node_modules/ /opt/app-root/node_modules/
COPY root /

RUN mkdir -p /opt/app-root/queue /opt/app-root/config \
    && chgrp 0   -R /opt/app-root/queue /opt/app-root/config \
    && chmod g=u -R /opt/app-root/queue /opt/app-root/config \
    && setcap cap_net_bind_service=+ep "$(command -v node)"

USER 1001

HEALTHCHECK CMD ["/healthcheck.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["npx", "--no-install", "haraka", "-c", "."]
