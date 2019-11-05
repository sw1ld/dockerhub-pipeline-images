FROM registry.access.redhat.com/ubi8/ubi AS TZDATA

FROM openshift/origin-cli:v3.11 AS OC_CLIENT

# If mutlistage docker builds are not supported in your enterprise environment
# an older version of skopeo is available via yum install in the extras repo/channel.

FROM golang:1.12 as SKOPEO

ARG SKOPEO_VERSION=v0.1.40

# From https://github.com/containers/skopeo/blob/master/Dockerfile.build
RUN apt-get update && apt-get install -y curl \
      libgpgme11-dev \
      libglib2.0-dev \
      libostree-dev

RUN mkdir -p $GOPATH/src/github.com/containers/skopeo \
    && curl -LsSf https://github.com/containers/skopeo/archive/${SKOPEO_VERSION}.tar.gz | tar xz --strip-components=1 -C $GOPATH/src/github.com/containers/skopeo \
    && cd $GOPATH/src/github.com/containers/skopeo && make binary-local DISABLE_CGO=1

FROM registry.access.redhat.com/ubi8/ubi-minimal

LABEL maintainer="adorsys GmbH & Co. KG" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="" \
      org.label-schema.description="" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

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
    KUBECONFIG=/var/local/lib/kube/config \
    HOME=/tmp

ARG RUSH_VERSION=0.4.2
ARG SOPS_VERSION=3.4.0
ARG JQ_VERSION=1.6
ARG HELM_VERSION=v2.15.2
ARG HELM_DIFF_VERSION=v2.11.0+5
ARG HELM_PUSH_VERSION=0.7.1
ARG HELM_SECRETS_VERSION=1.3.1

COPY root /

COPY --from=OC_CLIENT /usr/bin/oc /usr/local/bin/oc
COPY --from=SKOPEO /go/src/github.com/containers/skopeo/skopeo /usr/local/bin/skopeo

# https://bugzilla.redhat.com/show_bug.cgi?id=1611117
COPY --from=TZDATA /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
COPY --from=TZDATA /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/Europe/Berlin

RUN set -euo pipefail \
    && mkdir -p "${HELM_HOME}" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && echo -e '[docker-ce-stable]\nname=Docker CE Stable - $basearch\nbaseurl=https://download.docker.com/linux/centos/7/$basearch/stable\nenabled=0\ngpgcheck=1\ngpgkey=https://download.docker.com/linux/centos/gpg' > /etc/yum.repos.d/docker-ce.repo \
    && microdnf update -y \
    && microdnf install -y --enablerepo=docker-ce-stable git-core docker-ce-cli python3-pip gettext tar unzip findutils \
    && microdnf clean all \
## Install yq
    && curl -LsSf https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq \
    && pip3 --disable-pip-version-check install --compile --no-cache-dir yq \
## Install rush
    && curl -LsSf https://github.com/shenwei356/rush/releases/download/v${RUSH_VERSION}/rush_linux_amd64.tar.gz | tar xz -C /usr/local/bin \
## Install kubernetes helm
    && curl -LsSf https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz -C /usr/local/bin/ --strip-components=1 linux-amd64/helm  \
    && helm init --client-only \
    && helm repo remove local \
## Install helm plugins (manual installation without GH API)
    && mkdir "$(helm home)/plugins/helm-push" \
    && curl -LsSf https://github.com/chartmuseum/helm-push/releases/download/v${HELM_PUSH_VERSION}/helm-push_${HELM_PUSH_VERSION}_linux_amd64.tar.gz | tar -C "$(helm home)/plugins/helm-push" -zxf- \
    && curl -LsSf https://github.com/databus23/helm-diff/releases/download/${HELM_DIFF_VERSION}/helm-diff-linux.tgz | tar -C "$(helm home)/plugins" --warning=no-unknown-keyword -zxf- \
    && curl -LsSf https://github.com/futuresimple/helm-secrets/archive/v${HELM_SECRETS_VERSION}.tar.gz | tar -C "$(helm home)/plugins" -xzf- \
    && curl -LsSf https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops \
    && ln -s "$(helm home)/plugins/helm-secrets-${HELM_SECRETS_VERSION}/wrapper.sh" /usr/local/bin/helm-wrapper \
    && ln -s /usr/libexec/gpg-preset-passphrase /usr/local/bin/gpg-preset-passphrase \
    && chmod -R go+rw "$(helm home)" "${GNUPGHOME}" "$(dirname "$KUBECONFIG")" \
    && microdnf remove tar unzip -y \
## Reduce image size
    && microdnf install binutils -y \
    && strip /usr/local/bin/sops /usr/local/bin/skopeo /usr/local/bin/rush /usr/local/bin/oc /usr/local/bin/helm \
    && microdnf remove binutils -y \
    && microdnf clean all

USER 1001
