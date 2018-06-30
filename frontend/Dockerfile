FROM centos/nginx-112-centos7

USER 0

ENV TZ=Europe/Berlin

# https://github.com/sclorg/nginx-container/issues/58
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    sed -i '/^\s*location \/ {/ { N; /^\s*location \/ {\n\s*}/d }' "${NGINX_CONF_PATH}"

USER 1001

CMD ["/usr/libexec/s2i/run"]