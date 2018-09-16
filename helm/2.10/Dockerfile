FROM centos:7

LABEL maintainer="ysi@adorsys.de,joe@adorsys.de"

ARG COPY_IMAGE_VERSION=v2.0.0-rc.1
ARG HELM_VERSION=v2.10.0
ARG HELM_DIFF_VERSION=v2.10.0+1
ARG HELM_PUSH_VERSION=0.7.1
ARG HELM_SECRETS_VERSION=1.3.1

RUN set -euo pipefail \
    && yum install -y epel-release centos-release-openshift-origin \
    && yum install -y docker-client ansible origin-clients \
    && yum clean all \
    && rm -rf /var/cache/yum \
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
    && curl -LsSf https://github.com/futuresimple/helm-secrets/archive/v${HELM_SECRETS_VERSION}.tar.gz | tar -C "$(helm home)/plugins" -xzf- \
    && export SOPS_VERSION=$(grep SOPS_VERSION= "$(helm home)/plugins/helm-secrets-${HELM_SECRETS_VERSION}/install-binary.sh" | cut -d'"' -f2) \
    && curl -LsSf https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops \
## Install copy-docker-image
    && curl -LsSf -o /usr/local/bin/copy-docker-image "https://github.com/jkroepke/copy-docker-image/releases/download/${COPY_IMAGE_VERSION}/copy-docker-image_linux_amd64" \
    && chmod +x /usr/local/bin/copy-docker-image

