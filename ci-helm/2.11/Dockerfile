FROM centos:7

LABEL maintainer="ysi@adorsys.de,joe@adorsys.de"

# Required von helm secrets
ENV GNUPGHOME=/var/local/lib/gnupg/ \
    TERM=xterm \
    HELM_HOME=/var/local/lib/helm/ \
    KUBECONFIG=/var/local/lib/kube/config

ARG HELM_VERSION=v2.11.0
ARG HELM_DIFF_VERSION=v2.11.0+2
ARG HELM_PUSH_VERSION=0.7.1
ARG HELM_SECRETS_VERSION=1.3.1
ARG HELM_TILLER_VERSION=0.6.3

ADD root /

RUN set -euo pipefail \
    && mkdir -p "${HELM_HOME}" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && yum install -y epel-release centos-release-openshift-origin \
    && yum install -y git skopeo docker-client ansible origin-clients python2-pip jq unzip \
    && yum clean all \
    && rm -rf /var/cache/yum \
## Install yq
    && pip --disable-pip-version-check install -U --no-deps --compile --no-cache-dir yq \
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
    && export SOPS_VERSION=$(grep SOPS_VERSION= "$(helm home)/plugins/helm-secrets-${HELM_SECRETS_VERSION}/install-binary.sh" | cut -d'"' -f2) \
    && curl -LsSf https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops \
    && helm tiller install \
    && ln -s "$(helm home)/plugins/helm-secrets-${HELM_SECRETS_VERSION}/wrapper.sh" /usr/local/bin/helm-wrapper \
    && ln -s /usr/libexec/gpg-preset-passphrase /usr/local/bin/gpg-preset-passphrase \
    && chmod -R go+rw "$(helm home)" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && find "$(helm home)" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" -type d -exec chmod go+x {} +
