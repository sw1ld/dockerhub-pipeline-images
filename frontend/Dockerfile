FROM centos/nginx-112-centos7

USER 0

ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER 1001

CMD ["/usr/libexec/s2i/run"]