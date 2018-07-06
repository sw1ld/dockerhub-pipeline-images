FROM centos:7

ARG BAZEL_VERSION=0.14.1
ARG FIREFOX_VERSION=latest
ARG NODE_VERSION=8
ARG MAVEN_VERSION=3.5.4

ENV HOME=/tmp/ \
    TZ=Europe/Berlin \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx128M" \
    NODE_OPTIONS="--max_old_space_size=512" \
    PATH="$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH" \
    MAVEN_HOME=/usr/share/maven \
    MAVEN_CONFIG="$HOME/.m2"

ADD root /

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo -e '[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch\nenabled=0\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo && \
    echo -e '[nodesource]\nname=Node.js Packages for Enterprise Linux 7 - $basearch\nbaseurl=https://rpm.nodesource.com/pub_'${NODE_VERSION}'.x/el/7/$basearch\nenabled=0\ngpgcheck=1\ngpgkey=https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL' > /etc/yum.repos.d/nodesource.repo && \
    echo -e '[yarn]\nname=Yarn Repository\nbaseurl=https://dl.yarnpkg.com/rpm/\nenabled=0\ngpgcheck=1\ngpgkey=https://dl.yarnpkg.com/rpm/pubkey.gpg' > /etc/yum.repos.d/yarn.repo && \
    echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo && \
    yum install -y --enablerepo=google-chrome --enablerepo=docker-ce-stable --enablerepo=yarn --enablerepo=nodesource \
        zip unzip python bzip2 libXt git gcc-c++ make jq \
        docker-ce \
        nodejs yarn \
        apr java-1.8.0-openjdk-devel \
        google-chrome-stable && \
    yum clean all -y && rm -rf /var/cache/yum && \
    npm -g update && npm cache clear --force && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src && \
    ( \
      curl -LsSfJ -O https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 && \
      echo -n "$(curl -LsSf https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64.sha256)" | sha256sum -c && \
      mv bazel-${BAZEL_VERSION}-linux-x86_64 /usr/local/bin/bazel && chmod +x /usr/local/bin/bazel \
    ) && \
    (cd /opt && \
      curl  -fsSL "https://download.mozilla.org/?product=firefox-${FIREFOX_VERSION}&os=linux64&lang=en-US" | tar xj && \
      ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    ) && \
    (mkdir -p /usr/share/maven && cd /usr/share/maven && \
      curl -fsSL "https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -o apache-maven.tar.gz && \
      echo -n "$(curl -LsSf https://www-us.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha256)  apache-maven.tar.gz" | sha256sum -c && \
      tar -xzf apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
      rm -f apache-maven.tar.gz && \
      ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    ) && \
    echo "Bazel: " && bazel version && \
    echo "NodeJS: " && node --version && \
    echo "NPM (NodeJS): " && npm --version && \
    echo "YARN: " && yarn --version && \
    echo "Docker: " && docker --version && \
    echo "Java: " && java -version && \
    echo "Maven: " && mvn --version && \
    echo "Chrome: " && google-chrome-stable --version && \
    echo "Firefox: " && firefox --version && \
    cd /tmp && rm -rf ..?* .[!.]* *

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]

USER 1001
