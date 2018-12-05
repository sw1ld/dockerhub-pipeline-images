# Clair Scanner

With clair you can scan you images inside the CI pipeline


## gitlab-ci.yml
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
