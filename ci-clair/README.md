# [adorsys/ci-clair](https://hub.docker.com/r/adorsys/ci-clair/)

![](https://img.shields.io/docker/pulls/adorsys/ci-clair.svg?logo=docker&style=flat-square)
![](https://img.shields.io/docker/stars/adorsys/ci-clair.svg?logo=docker&style=flat-square)

## Description

Provides a local clair scanner. With clair you can scan you images inside the CI pipeline

See also:

* https://github.com/coreos/clair
* https://github.com/arminc/clair-local-scan

## Tags

| Name | Description | Size |
| ---- | ----------- | ---- |
| latest | - | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-clair.svg?style=flat-square) |


## CI Examples

### gitlab-ci.yml
```yaml
scan:
  stage: scan
  image: 
    name: adorsys/ci-clair
  services:
    - name: arminc/clair-db:latest
      alias: postgres
  before_script:
    - /clair -config=/config/config.yaml -log-level=warn &
    - echo "$CI_BUILD_TOKEN" | docker login -u gitlab-ci-token --password-stdin $CI_REGISTRY
    - docker pull $CI_REGISTRY_IMAGE:latest
    - wait-for-clair
  script:
    - clair-scanner -c http://localhost:6060 --ip $(hostname -i) "$CI_REGISTRY_IMAGE:latest"
```
