FROM centos:7 AS TCNATIVE

RUN yum install -y apr-devel openssl-devel java-1.8.0-openjdk-devel tar gzip gcc make redhat-rpm-config

RUN set -x \
    # https://github.com/infosiftr/tomcat/blob/5f1abae99c0b1ebbd4f020bc4b5696619d948cfd/7/jre8-alpine/Dockerfile
    && nativeBuildDir="$(mktemp -d)" \
    && nativeVersion=$(curl -sSf "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/" | sed -nE 's/.*<a href="([0-9]+\.[0-9]+.[0-9]+)\/">.*/\1/p' | tail -n1) \
    && curl -sSf "https://www-eu.apache.org/dist/tomcat/tomcat-connectors/native/${nativeVersion}/source/tomcat-native-${nativeVersion}-src.tar.gz" | tar -zxv -C "$nativeBuildDir" --strip-components=1 \
    && export CATALINA_HOME="$PWD" \
    && cd "$nativeBuildDir/native" \
    && ./configure --with-apr=/usr/bin/apr-1-config \
              --with-java-home=/usr/lib/jvm/java-openjdk  \
              --with-ssl=yes \
              --prefix=/usr \
    && make && make install

FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

ARG RUSH_VERSION=0.4.1
ARG MAVEN_VERSION=3.6.1

ENV HOME=/tmp \
    TZ=Europe/Berlin \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx1G" \
    NODE_OPTIONS="--max_old_space_size=1024" \
    MAVEN_HOME="/usr/share/maven" \
    MAVEN_CONFIG="/usr/local/share/.m2" \
    NVM_DIR="/usr/local/share/nvm" \
    JABBA_HOME="/usr/local/share/jabba" \
    BASH_ENV=/enable.sh \
    ENV=/enable.sh

COPY root /

COPY --from=TCNATIVE /usr/lib/libtcnative*so /usr/lib/

RUN set -euo pipefail \
    && useradd -d "${HOME}" -M -u 1001 -g 0 default \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo \
    && yum update -y \
    && yum install -y epel-release \
    && yum install -y --enablerepo=docker-ce-stable \
        python bzip2 gcc-c++ make \
        docker-ce-cli \
    && yum clean all -y && rm -rf /var/cache/yum \
    && chmod g=u /etc/passwd \
    && mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src

RUN yum install -y \
        java-1.8.0-openjdk-devel java-11-openjdk-devel \
    && yum clean all -y && rm -rf /var/cache/yum

RUN mkdir -p "${NVM_DIR}" && cd "${NVM_DIR}" \
    && curl "https://raw.githubusercontent.com/creationix/nvm/master/install.sh" | bash \
    && rm -rf .git test \
    && echo -e "npm\nyarn" > default-packages \
    && . "${NVM_DIR}/nvm.sh" \
    && nvm install 10 \
    && nvm install 12 \
    && nvm cache clear \
    && nvm alias default 10 \
    && rm -rf /home/default/.npm/ \
    && for prog in "${NVM_DIR}/versions/node/$(. "${NVM_DIR}/nvm.sh"; nvm current)/bin/"*; do ln -s "$prog" "/usr/local/bin/$(basename "${prog}")"; done \
    && find "${NVM_DIR}" -type d -exec chmod g+x {} + \
    && chmod -R g+rw "${NVM_DIR}" \
    && cd /tmp && rm -rf ..?* .[!.]* *

RUN cd /opt \
    # Less secure then git clone ... bash install.sh ?
    && curl -fsSL "https://github.com/shyiko/jabba/raw/master/install.sh" | bash \
    && . "${JABBA_HOME}/jabba.sh" \
    && jabba link system@1.11 /usr/lib/jvm/java-11 \
    && jabba link system@1.8 /usr/lib/jvm/java-1.8.0 \
    && jabba alias default system@1.8 \
    && chmod -R g+rw "${JABBA_HOME}"  \
    && cd /tmp && rm -rf ..?* .[!.]* * \
    && mkdir -p "${MAVEN_HOME}" && cd "${MAVEN_HOME}" \
    && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" \
    && sha512sum -c apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
    && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C "${MAVEN_HOME}" --strip-components=1 \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
    && ln -s "${MAVEN_HOME}/bin/mvn" /usr/bin/mvn \
    && mkdir -p "${MAVEN_CONFIG}" \
    && chmod -R g+rw "${MAVEN_CONFIG}" \
    && cd /tmp && rm -rf ..?* .[!.]* * \
    && ln -s /enable.sh /tmp/.bashrc

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]

USER 1001
