FROM adorsys/ci-build AS BUILD
COPY . .
RUN bash -c "nvm use && npm ci"

FROM adorsys/node:10

VOLUME /var/spool/haraka

USER 0

COPY --from=BUILD /opt/app-root/src/node_modules/ /opt/app-root/node_modules/
COPY plugins/ /opt/app-root/plugins/

RUN mkdir /opt/app-root/queue /opt/app-root/config \
    && chgrp 0   -R /opt/app-root/queue /opt/app-root/config \
    && chmod g=u -R /opt/app-root/queue /opt/app-root/config \
    && setcap cap_net_bind_service=+ep "$(command -v node)"

USER 1001

CMD ["npx", "--no-install", "haraka", "-c", "."]
