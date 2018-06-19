FROM centos:7

EXPOSE 8080

# discard npm update warnings
ENV NO_UPDATE_NOTIFIER=1

ADD root /

RUN yum install -y centos-release-scl-rh && \
    yum install -y rh-nodejs8 rh-nodejs8-npm && \
    yum clean all -y && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001