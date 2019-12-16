FROM centos:8 AS RPM

# https://github.com/nodesource/distributions/issues/845#issuecomment-564824018
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y yum-utils
RUN yumdownloader nodejs --disablerepo=AppStream
RUN mv nodejs*nodesource.x86_64.rpm /opt

FROM registry.access.redhat.com/ubi8/ubi AS TZDATA

FROM registry.access.redhat.com/ubi8/ubi-minimal

LABEL maintainer="adorsys GmbH & Co. KG" \
      vendor="adorsys GmbH & Co. KG" \
      name="adorsys/node:10" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="adorsys/node:12" \
      io.k8s.display-name="adorsys/node:12" \
      summary="adorsys/node:12" \
      io.k8s.description="adorsys/node:12" \
      org.label-schema.description="adorsys/node:12" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

EXPOSE 3000

# discard npm update warnings
ENV TZ=Europe/Berlin \
    LC_ALL=C.UTF-8 \
    NO_UPDATE_NOTIFIER=1 \
    ENABLE_AUTO_NODE_MEMORY_LIMIT=true \
    NODE_MEMORY_LIMIT_PERCENT=80

# https://bugzilla.redhat.com/show_bug.cgi?id=1611117
COPY --from=TZDATA /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
COPY --from=TZDATA /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/Europe/Berlin
COPY --from=RPM /opt/*.rpm /tmp/

WORKDIR /opt/app-root

RUN microdnf update -y && microdnf clean all && rm -rf /var/cache/yum \
    && echo -e '[nodesource]\nname=nodesource\nbaseurl=https://rpm.nodesource.com/pub_12.x/el/8/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL' > /etc/yum.repos.d/nodesource.repo \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && microdnf install -y openssl python2 \
    && rpm -ivh --nodeps /tmp/*.rpm \
    && rm /tmp/*.rpm \
    && microdnf clean all -y \
    && rm -f nodejs-*nodesource.x86_64.rpm \
    && npm install -g npm yarn \
    && npm cache clear --force \
    && chmod g=u /etc/passwd \
    && mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

COPY root /

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001
