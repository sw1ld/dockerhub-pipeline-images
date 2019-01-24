FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

# START FROM adorsys/ci-helm:2.11
ARG SOPS_VERSION=3.0.4
ARG HELM_VERSION=v2.11.0
ARG HELM_DIFF_VERSION=v2.11.0+3
ARG HELM_PUSH_VERSION=0.7.1
ARG HELM_SECRETS_VERSION=1.3.1
ARG HELM_TILLER_VERSION=0.6.7
# END FROM adorsys/ci-helm:2.11

ARG RUSH_VERSION=0.4.0
ARG MAVEN_VERSION=3.6.0
ARG JMETER_VERSION=5.0

ENV HOME=/tmp \
    TZ=Europe/Berlin \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx1G" \
    NODE_OPTIONS="--max_old_space_size=1024" \
    JMETER_HOME="/usr/share/jmeter" \
    MAVEN_HOME="/usr/share/maven" \
    MAVEN_CONFIG="/usr/local/share/.m2" \
    NVM_DIR="/usr/local/share/nvm" \
    JABBA_HOME="/usr/local/share/jabba" \
    BASH_ENV=/enable.sh \
    ENV=/enable.sh

ADD root /

RUN set -euo pipefail \
    && useradd -d "${HOME}" -M -u 1001 -g 0 default \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && echo -e '[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch\nenabled=0\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo \
    && echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo \
    && yum update -y \
    && yum install -y epel-release \
    && yum install -y --enablerepo=google-chrome --enablerepo=docker-ce-stable \
        iproute zip unzip python bzip2 libXt git gcc-c++ make jq \
        docker-ce-cli skopeo \
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
    && (mkdir -p "${MAVEN_HOME}" && cd "${MAVEN_HOME}" \
      && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
      && curl -fsSLO "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" \
      && sha512sum -c apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
      && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C "${MAVEN_HOME}" --strip-components=1 \
      && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
      && ln -s "${MAVEN_HOME}/bin/mvn" /usr/bin/mvn \
    ) \
    && (mkdir -p "${JMETER_HOME}" && cd "${JMETER_HOME}" \
      && curl -fsSLO "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"  \
      && curl -fsSLO "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz.sha512" \
      && sha512sum -c apache-jmeter-${JMETER_VERSION}.tgz.sha512 \
      && tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C "${JMETER_HOME}" --strip-components=1 --exclude='docs' \
      && rm -f apache-jmeter-${JMETER_VERSION}.tgz apache-jmeter-${JMETER_VERSION}.tgz.sha512 \
      && ln -s "${JMETER_HOME}/bin/jmeter" /usr/bin/jmeter \
    ) \
    && curl -LsSf https://github.com/shenwei356/rush/releases/download/v${RUSH_VERSION}/rush_linux_amd64.tar.gz | tar xz -C /usr/local/bin \
    && cd /tmp && rm -rf ..?* .[!.]* * \
    && mkdir -p "${MAVEN_CONFIG}" \
    && chmod -R g+rw "${NVM_DIR}" "${JABBA_HOME}" "${MAVEN_CONFIG}" \
    && for prog in "${NVM_DIR}/versions/node/$(. "${NVM_DIR}/nvm.sh"; nvm current)/bin/"*; do ln -s "$prog" "/usr/local/bin/$(basename "${prog}")"; done \
    && find "${NVM_DIR}" -type d -exec chmod g+x {} + \
    && find "${JABBA_HOME}" -type d -exec chmod g+x {} + \

# START FROM adorsys/ci-helm:2.11
    && yum install -y epel-release centos-release-openshift-origin \
    && yum install -y --enablerepo=docker-ce-stable git docker-ce-cli origin-clients python2-pip jq unzip \
    && yum clean all \
    && rm -rf /var/cache/yum \
## Install yq
    && pip --disable-pip-version-check install -U --compile --no-cache-dir yq \
## Install kubernetes helm
    && curl -LsSf -O https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 \
    && helm init --client-only \
    && helm repo remove local \
## Install helm plugins (manual installation without GH API)
    && mkdir "$(helm home)/plugins/helm-push" \
    && curl -LsSf https://github.com/chartmuseum/helm-push/releases/download/v${HELM_PUSH_VERSION}/helm-push_${HELM_PUSH_VERSION}_linux_amd64.tar.gz | tar -C "$(helm home)/plugins/helm-push" -zxf- \
    && curl -LsSf https://github.com/databus23/helm-diff/releases/download/${HELM_DIFF_VERSION}/helm-diff-linux.tgz | tar -C "$(helm home)/plugins" --warning=no-unknown-keyword -zxf- \
    && curl -LsSf https://github.com/rimusz/helm-tiller/archive/v${HELM_TILLER_VERSION}.tar.gz| tar -C "$(helm home)/plugins" -xzf- \
    && curl -LsSf https://github.com/futuresimple/helm-secrets/archive/v${HELM_SECRETS_VERSION}.tar.gz | tar -C "$(helm home)/plugins" -xzf- \
    && curl -LsSf https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops \
    && helm tiller install \
    && ln -s "$(helm home)/plugins/helm-secrets-${HELM_SECRETS_VERSION}/wrapper.sh" /usr/local/bin/helm-wrapper \
    && ln -s /usr/libexec/gpg-preset-passphrase /usr/local/bin/gpg-preset-passphrase
# END FROM adorsys/ci-helm:2.11

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]

USER 1001
