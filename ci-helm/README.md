[![](https://img.shields.io/docker/pulls/adorsys/ci-helm.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ci-helm/)
[![](https://img.shields.io/docker/stars/adorsys/ci-helm.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ci-helm/)

# adorsys/ci-helm

https://hub.docker.com/r/adorsys/ci-helm/

## Description

Provides Helm (and some plugins) also docker skopeo and ansible (<=2.11).

### Installed Helm Plugins

* helm-diff
  https://github.com/databus23/helm-diff
* helm-push
  https://github.com/chartmuseum/helm-push
* helm-secrets (incl. sops and gpg)
  https://github.com/futuresimple/helm-secrets
* helm-kubeval
  https://github.com/instrumenta/helm-kubeval

### Additional software

* [kubeval](https://github.com/instrumenta/kubeval)
* [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
* [skopeo](https://github.com/containers/skopeo)
* [jq](https://stedolan.github.io/jq/)
* [yq](https://yq.readthedocs.io/en/latest/)
* [rush](https://github.com/shenwei356/rush)

## Tags*__*

| Name | Description | Size |
| ---- | ----------- | ---- |
| `latest` | Reference the latest recommend version | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/latest.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm) |
| `3.0` | helm 3.0 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/3.0.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:3.0) |
| `2.16` | helm 2.16 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.16.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.16) |
| `2.15` | helm 2.15 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.15.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.15) |
| `2.14` | helm 2.14 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.14.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.14) |
| `2.13` | helm 2.13 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.13.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.13) |
| `2.12` | helm 2.12 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.12.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.12) |
| `2.11` | helm 2.11 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.11.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.11) |
| `2.10` | helm 2.10 | [![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.10.svg?style=flat-square)](https://microbadger.com/images/adorsys/ci-helm:2.10) |

# Gitlab

```yaml
lint:
  stage: lint
  before_script:
    - eval $(gpg-agent --daemon --quiet --allow-preset-passphrase)
    - echo -n "${GPG_KEY}" | gpg --quiet --batch --import -
    - gpg-preset-passphrase --preset --passphrase ${GPG_KEY_PASSPHRASE} $(gpg-keyid <(echo -n "${GPG_KEY}"))
  script:
    - helm secrets lint . -f secrets/dev/secrets.yaml
  after_script:
    - pkill gpg-agent
```
