# [adorsys/ci-build](https://hub.docker.com/r/adorsys/ci-build/)

![](https://img.shields.io/docker/pulls/adorsys/ci-build.svg?logo=docker&style=flat-square)
![](https://img.shields.io/docker/stars/adorsys/ci-build.svg?logo=docker&style=flat-square)

## Description

The default build image. 

Software list:

* Java 8 and 11 (choosable via [JABBA](https://github.com/shyiko/jabba); default 8)
* Node 8 and 10 (choosable via [NVM](https://github.com/creationix/nvm); default 8)
* NPM and [YARN](https://yarnpkg.com/lang/en/)
* Docker CE
* Maven
* Chrome
* Firefox
* [skopeo](https://github.com/containers/skopeo)
* [jq](https://stedolan.github.io/jq/)
* [yq](https://yq.readthedocs.io/en/latest/)
* [rush](https://github.com/shenwei356/rush)
* Build Tools like gcc (required for some node dependencies)

We try to avoid version pinning. Prepare to always get the latest version.

## Tags

| Name | Description | Size | 
| ---- | ----------- | ---- |
| latest | - | ![](https://img.shields.io/microbadger/image-size/adorsys/ci-build.svg?style=flat-square) |
| YYYYMM | Monthly Snapshots | - |

## CI Examples

### Use Java 11 in your job

Create a file calling `.jabbarc` in the project root with this content
```
system@1.11'
```
and use `jabba use` inside your CI.


### Use Node 8 in your job

Create a file calling `.nvmrc` in the project root with this content
```
10
```
and use `nvm use` inside your CI.


### Best Practice default options for maven

Based on the recommendation from [Gitlab CI](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/lib/gitlab/ci/templates/Maven.gitlab-ci.yml).
It avoid all the spammy transfer output
```yaml
variables:
  MAVEN_CLI_OPTS: "--batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true"
  MAVEN_OPTS: "-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Dorg.slf4j.simpleLogger.showDateTime=true -Djava.awt.headless=true"
```

### Copy Images without Docker

````yaml
# From Gitlab to Openshift
    - >-
      skopeo copy
      --src-creds=${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD}
      --dest-creds=openshift:${OPENSHIFT_TOKEN}
      "docker://${OPENSHIFT_REGISTRY}/namespace/image:${CI_COMMIT_REF_NAME}"
      "docker://${HARBOR_REGISTRY}/project/imagename:${CI_COMMIT_REF_NAME}"
# From Gitlab to Harbor
    - >-
      skopeo copy
      --src-creds=${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD}
      --dest-creds=${HARBOR_USER}:${HARBOR_TOKEN}
      "docker://${CI_REGISTRY_IMAGE}:${CI_COMMIT_TAG}"
      "docker://${HARBOR_REGISTRY}/project/imagename:${CI_COMMIT_TAG}"
# From Openshift to Harbor
    - >-
      skopeo copy
      --src-creds=openshift:${OPENSHIFT_TOKEN}
      --dest-creds=${HARBOR_USER}:${HARBOR_TOKEN}
      "docker://${OPENSHIFT_REGISTRY}/namespace/image:${CI_COMMIT_TAG}"
      "docker://${HARBOR_REGISTRY}/project/imagename:${CI_COMMIT_TAG}"

````
