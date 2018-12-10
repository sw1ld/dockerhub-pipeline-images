FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

ARG MAVEN_VERSION=3.6.0
ARG JMETER_VERSION=5.0

ENV HOME=/home/default \
    TZ=Europe/Berlin \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx128M" \
    NODE_OPTIONS="--max_old_space_size=512" \
    MAVEN_HOME=/usr/share/maven \
    MAVEN_CONFIG="$HOME/.m2" \
    NVM_DIR="/usr/local/share/nvm" \
    JABBA_HOME="/usr/local/share/jabba" \
    BASH_ENV=/enable.sh \
    ENV=/enable.sh

ADD root /

RUN set -euo pipefail \
    && useradd -d "${HOME}" -u 1001 -g 0 default \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && echo -e '[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch\nenabled=0\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo \
    && echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo \
    && yum update -y \
    && yum install -y epel-release \
    && yum install -y --enablerepo=google-chrome --enablerepo=docker-ce-stable \
        zip unzip python bzip2 libXt git gcc-c++ make jq \
        docker-ce skopeo \
        tomcat-native java-1.8.0-openjdk-devel java-11-openjdk-devel \
        google-chrome-stable \
    && yum clean all -y && rm -rf /var/cache/yum \
    && chmod g=u /etc/passwd \
    && mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src \
    && ( mkdir -p "${NVM_DIR}" && cd "${NVM_DIR}" \
      && curl "https://raw.githubusercontent.com/creationix/nvm/master/install.sh" | bash \
      && echo -e "npm\nyarn" > default-packages \
      && . "${NVM_DIR}/nvm.sh" \
      && nvm install 8 \
      && nvm install 10 \
      && nvm cache clear \
      && nvm alias default 8 \
      && rm -rf /home/default/.npm/ \
    ) \
    && (cd /opt \
      # Less secure then git clone ... bash install.sh ?
      && curl -fsSL "https://github.com/shyiko/jabba/raw/master/install.sh" | bash \
      && . "${JABBA_HOME}/jabba.sh" \
      && jabba link system@1.11 /usr/lib/jvm/java-11 \
      && jabba link system@1.8 /usr/lib/jvm/java-1.8.0 \
      && jabba alias default system@1.8 \
    ) \
    && (cd /opt \
      && curl  -fsSL "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" | tar xj \
      && ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    ) \
    && (mkdir -p /usr/share/maven && cd /usr/share/maven \
      && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
      && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" \
      && sha512sum -c apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
      && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/share/maven --strip-components=1 \
      && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
      && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    ) \
    && (mkdir -p /usr/share/jmeter && cd /usr/share/jmeter \
      && curl -fsSLO "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"  \
      && curl -fsSLO "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz.sha512" \
      && sha512sum -c apache-jmeter-${JMETER_VERSION}.tgz.sha512 \
      && tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /usr/share/jmeter --strip-components=1 --exclude='docs' \
      && rm -f apache-jmeter-${JMETER_VERSION}.tgz apache-jmeter-${JMETER_VERSION}.tgz.sha512 \
      && ln -s /usr/share/jmeter/bin/jmeter /usr/bin/jmeter \
    ) \
    && cd /tmp && rm -rf ..?* .[!.]* * \
    && chmod -R g+rw "${NVM_DIR}" "${JABBA_HOME}" \
    && find "${NVM_DIR}" -type d -exec chmod g+x {} + \
    && find "${JABBA_HOME}" -type d -exec chmod g+x {} +

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]

USER 1001
