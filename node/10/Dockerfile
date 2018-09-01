FROM centos:7

EXPOSE 8080

# discard npm update warnings
ENV NO_UPDATE_NOTIFIER=1\
    TZ=Europe/Berlin

WORKDIR /opt/app-root

RUN echo -e '[nodesource]\nname=nodesource\nbaseurl=https://rpm.nodesource.com/pub_10.x/el/7/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL' > /etc/yum.repos.d/nodesource.repo && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yum install -y nodejs && \
    yum clean all -y && \
    npm install -g npm yarn && \
    npm cache clear --force && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

ADD root /

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001