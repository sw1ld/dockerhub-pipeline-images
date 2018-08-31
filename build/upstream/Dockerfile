FROM centos:7

ARG FIREFOX_VERSION=latest
ARG NODE_VERSION=8
ARG MAVEN_VERSION=3.5.4
ARG JMETER_VERSION=4.0

ENV HOME=/home/default
ENV TZ=Europe/Berlin \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx128M" \
    NODE_OPTIONS="--max_old_space_size=512" \
    PATH="$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH" \
    MAVEN_HOME=/usr/share/maven \
    MAVEN_CONFIG="$HOME/.m2" \
    BASH_ENV=/enable.sh \
    ENV=/enable.sh

ADD root /

RUN useradd -d "${HOME}" -u 1001 -g 0 default && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo -e '[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch\nenabled=0\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo && \
    yum install -y --enablerepo=google-chrome \
        zip unzip python bzip2 libXt git gcc-c++ make jq \
        docker-client \
        apr java-1.8.0-openjdk-devel \
        google-chrome-stable && \
    yum clean all -y && rm -rf /var/cache/yum && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src && \
    ( \
      git clone https://github.com/creationix/nvm.git "${HOME}/.nvm/" && \
      cd "${HOME}/.nvm/" && \
      git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
      echo -e "npm\nyarn" > default-packages && \
      . "${HOME}/.nvm/nvm.sh" && \
      nvm install 8 && \
      nvm install 10 && \
      nvm cache clear && \
      nvm alias default ${NODE_VERSION} && \
      rm -rf /home/default/.npm/ \
    ) && \
    (cd /opt && \
      curl  -fsSL "https://download.mozilla.org/?product=firefox-${FIREFOX_VERSION}&os=linux64&lang=en-US" | tar xj && \
      ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    ) && \
    (mkdir -p /usr/share/maven && cd /usr/share/maven && \
      curl -fsSLO "https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
      curl -fsSLO "https://www-us.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" && \
      echo -n "$(cat apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512)  apache-maven-${MAVEN_VERSION}-bin.tar.gz" | sha512sum -c && \
      tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/share/maven --strip-components=1 && \
      rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 && \
      ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    ) && \
    (mkdir -p /usr/share/jmeter && cd /usr/share/jmeter && \
      curl -fsSLO "https://www-eu.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"  && \
      curl -fsSLO "https://www-us.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz.sha512" && \
      sha512sum -c apache-jmeter-${JMETER_VERSION}.tgz.sha512 && \
      tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /usr/share/jmeter --strip-components=1 && \
      rm -f apache-jmeter-${JMETER_VERSION}.tgz apache-jmeter-${JMETER_VERSION}.tgz.sha512 && \
      ln -s /usr/share/jmeter/bin/jmeter /usr/bin/jmeter \
    ) && \
    cd /tmp && rm -rf ..?* .[!.]* * && \
    . "${HOME}/.nvm/nvm.sh" && \
    nvm exec 8 npm cache clear --force && \
    nvm exec 10 npm cache clear --force

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]

USER 1001
