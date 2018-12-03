FROM centos/nginx-112-centos7

LABEL maintainer="adorsys GmbH & Co. KG"

USER 0

ENV TZ=Europe/Berlin

COPY root/docker-entrypoint.sh /
COPY root/opt/app-root/etc/nginx.default.d /opt/app-root/etc/nginx.default.d

# https://github.com/sclorg/nginx-container/issues/58
RUN yum update -y && yum clean all && rm -rf /var/cache/yum \
    && sed -i '/^\s*location \/ {/ { N; /^\s*location \/ {\n\s*}/d }' "${NGINX_CONF_PATH}" \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && ln -sf /opt/rh/rh-nginx112/root/usr/share/nginx/html/404.html /opt/app-root/src/404.html \
    && ln -sf /opt/rh/rh-nginx112/root/usr/share/nginx/html/50x.html /opt/app-root/src/50x.html

USER default

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/libexec/s2i/run"]
