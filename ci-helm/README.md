# [adorsys/ci-helm](https://hub.docker.com/r/adorsys/ci-helm/)

![](https://img.shields.io/docker/pulls/adorsys/ci-helm.svg?logo=docker&style=flat-square)
![](https://img.shields.io/docker/stars/adorsys/ci-helm.svg?logo=docker&style=flat-square)

## Description

Provides Helm (and some plugins) also docker skopeo and ansible (<=2.11).

### Installed Helm Plugins

* helm-diff
  https://github.com/databus23/helm-diff
* helm-push
  https://github.com/chartmuseum/helm-push
* helm-secrets (incl. sops and gpg)
  https://github.com/futuresimple/helm-secrets
* helm-tiller
  https://github.com/rimusz/helm-tiller

### Additional software

* [ansible](https://www.ansible.com/) (<=2.11)
* [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
* [skopeo](https://github.com/containers/skopeo)
* [jq](https://stedolan.github.io/jq/)
* [yq](https://yq.readthedocs.io/en/latest/)
* [rush](https://github.com/shenwei356/rush)

## Tags

| Name | Description | Size |
| ---- | ----------- | ---- |
| `latest` | Reference the latest recommend version | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/latest.svg?style=flat-square) |
| `2.10` | helm 2.10 | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.10.svg?style=flat-square) |
| `2.11` | helm 2.11 | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.11.svg?style=flat-square) |
| `2.12` | helm 2.12 | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-helm/2.12.svg?style=flat-square) |

# Gitlab

```yaml
lint:
  stage: lint
  before_script:
    - eval $(gpg-agent --daemon --quiet --allow-preset-passphrase)
    - echo -n "${GPG_KEY}" | gpg --quiet --batch --import -
    - gpg-preset-passphrase --preset --passphrase ${GPG_KEY_PASSPHRASE} $(gpg-keyid <(echo -n "${GPG_KEY}"))
  script:
    - helm-wrapper lint . -f secrets/dev/secrets.yaml
  after_script:
    - pkill gpg-agent
```
