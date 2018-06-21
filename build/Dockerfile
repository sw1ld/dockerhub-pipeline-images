FROM centos:7

ARG BAZEL_VERSION=0.14.1
ARG FIREFOX_VERSION=latest

ENV HOME=/tmp/ \
    NO_UPDATE_NOTIFIER=1 \
    JAVA_TOOL_OPTIONS="-Xmx128M" \
    NODE_OPTIONS="--max_old_space_size=768" \
    BASH_ENV=/scl_enable.sh \
    ENV=/scl_enable.sh \
    PROMPT_COMMAND=". /scl_enable.sh" \
    TZ=Europe/Berlin

ADD root /

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo -e '[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo && \
    yum install -y centos-release-scl-rh && \
    yum install -y \
        zip unzip python bzip2 libXt git make gcc \
        docker-client \
        rh-nodejs8 rh-nodejs8-npm \
        apr java-1.8.0-openjdk-devel rh-maven35 \
        google-chrome-stable && \
    yum clean all -y && \
    chmod g=u /etc/passwd && \
    mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src && \
    scl enable rh-nodejs8 -- npm install -g yarn && \
    scl enable rh-nodejs8 -- npm cache clear --force && \
    curl -LsSfJ -O https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 && \
    ([ "$(sha256sum bazel-${BAZEL_VERSION}-linux-x86_64)" == "$(curl -LsSf https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64.sha256)" ] || exit "Hash sum mismatch") && \
    mv bazel-${BAZEL_VERSION}-linux-x86_64 /usr/local/bin/bazel && chmod +x /usr/local/bin/bazel && \
    (cd /opt && curl -o firefox.tar.bz2 -fsSL "https://download.mozilla.org/?product=firefox-${FIREFOX_VERSION}&os=linux64&lang=en-US" && tar xfj firefox.tar.bz2 && rm -f firefox.tar.bz2) && \
    ln -s /opt/firefox/firefox /usr/local/bin/firefox && \
    echo "Bazel: " && bazel version && \
    echo "NodeJS: " && scl enable rh-nodejs8 -- node --version && \
    echo "NPM8: " && scl enable rh-nodejs8 -- npm --version && \
    echo "YARN: " && scl enable rh-nodejs8 -- yarn --version && \
    echo "Java: " && java -version && \
    echo "Maven: " && scl enable rh-maven35 -- mvn --version && \
    echo "Chrome: " && google-chrome-stable --version && \
    echo "Firefox: " && firefox --version && \
    rm -rf /tmp/*

WORKDIR /opt/app-root/src

ENTRYPOINT ["/docker-entrypoint.sh"]

USER 1001