# If mutlistage docker builds are not supported in your enterprise environment
# an older version of skopeo is available via yum install in the extras repo/channel.

FROM golang:1.12 as SKOPEO

ARG SKOPEO_VERSION=v0.1.35

# From https://github.com/containers/skopeo/blob/master/Dockerfile.build
RUN apt-get update && apt-get install -y curl \
      libgpgme11-dev \
      libglib2.0-dev \
      libostree-dev

RUN mkdir -p $GOPATH/src/github.com/containers/skopeo \
    && curl -LsSf https://github.com/containers/skopeo/archive/${SKOPEO_VERSION}.tar.gz | tar xz --strip-components=1 -C $GOPATH/src/github.com/containers/skopeo \
    && cd $GOPATH/src/github.com/containers/skopeo && make binary-local DISABLE_CGO=1

FROM centos:7

LABEL maintainer="adorsys GmbH & Co. KG"

# GNUPGHOME: Required von helm secrets
# Workaround for
#
# could not decrypt data key with PGP key: golang.org/x/crypto/openpgp error: Could not load secring: open ~/.gnupg/secring.gpg: no such file or directory;
#
# Since the current user does not have $HOME (in passwd) and ~ can resolve to the current home a PGP home must be defined.
# See also: https://github.com/mozilla/sops/blob/108e66f46f07a3c5dd0717d298f15558594baba6/pgp/keysource.go#L245
ENV GNUPGHOME=/var/local/lib/gnupg/ \
    TERM=xterm \
    HELM_HOME=/var/local/lib/helm/ \
    KUBECONFIG=/var/local/lib/kube/config

ARG RUSH_VERSION=0.4.1
ARG SOPS_VERSION=3.2.0
ARG HELM_VERSION=v2.13.0
ARG HELM_DIFF_VERSION=v2.11.0+3
ARG HELM_PUSH_VERSION=0.7.1
ARG HELM_SECRETS_VERSION=1.3.1
ARG HELM_TILLER_VERSION=0.6.7

ADD root /

COPY --from=SKOPEO /go/src/github.com/containers/skopeo/skopeo /usr/local/bin/skopeo

RUN set -euo pipefail \
    && mkdir -p "${HELM_HOME}" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo \
    && yum install -y epel-release centos-release-openshift-origin \
    && yum install -y --enablerepo=docker-ce-stable git docker-ce-cli origin-clients python2-pip jq unzip gettext \
    && yum clean all \
    && rm -rf /var/cache/yum \
## Install yq
    && pip --disable-pip-version-check install -U --compile --no-cache-dir yq \
## Install rush
    && curl -LsSf https://github.com/shenwei356/rush/releases/download/v${RUSH_VERSION}/rush_linux_amd64.tar.gz | tar xz -C /usr/local/bin \
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
    && ln -s /usr/libexec/gpg-preset-passphrase /usr/local/bin/gpg-preset-passphrase \
    && chmod -R go+rw "$(helm home)" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && find "$(helm home)" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" -type d -exec chmod go+x {} +
