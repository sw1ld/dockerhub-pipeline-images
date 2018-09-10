FROM centos/nginx-112-centos7

USER 0

ENV TZ=Europe/Berlin

COPY root/docker-entrypoint.sh /
COPY --chown=default:0 root/opt/app-root /opt/

# https://github.com/sclorg/nginx-container/issues/58
RUN sed -i '/^\s*location \/ {/ { N; /^\s*location \/ {\n\s*}/d }' "${NGINX_CONF_PATH}" && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER default

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/libexec/s2i/run"]