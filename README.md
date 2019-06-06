[![Build Status](https://img.shields.io/travis/com/adorsys/dockerhub-pipeline-images/master.svg?longCache=true&style=flat-square)](https://travis-ci.com/adorsys/dockerhub-pipeline-images)

# adorsys docker pipeline images

Primary used to build and distribute software at adorsys.

# Getting updates

All images are build daily at travis to receive daily OS update. Most of the images are squashed into one to
reduce the image size. 

## Flavors

By default all images based on CentOS except `awscli`. Some images have a `alpine` flavor to get the minimal footprint.

# Images

| Name | Description | Pulls |
|------|-------------|-------|
| [adorsys/ansible](ansible/README.md) | Run Ansible inside Docker | [![](https://img.shields.io/docker/pulls/adorsys/ansible.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ansible) |
| [adorsys/arc42-tools](arc42-tools/README.md) | Generate arc42 documentation for gitlab pages. Also supports plantuml | [![](https://img.shields.io/docker/pulls/adorsys/arc42-tools.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/arc42-tools) |
| [adorsys/awscli](awscli/README.md) | Provides awscli for terraform | [![](https://img.shields.io/docker/pulls/adorsys/awscli.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/awscli) |
| [adorsys/ci-build](ci-build/README.md) | Generic build image for Gitlab CI | [![](https://img.shields.io/docker/pulls/adorsys/ci-build.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ci-build) |
| [adorsys/ci-helm](ci-helm/README.md) | Deploy your environment with helm! Multiple versions of helm supported | [![](https://img.shields.io/docker/pulls/adorsys/ci-helm.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ci-helm) |
| [adorsys/ci-clair](ci-clair/README.md) | Scan your images with clair before release them  | [![](https://img.shields.io/docker/pulls/adorsys/ci-clair.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/ci-clair) |
| [adorsys/nginx](nginx/README.md) | Base image for distribute static files and SPAs. | [![](https://img.shields.io/docker/pulls/adorsys/nginx.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/nginx) |
| [adorsys/java](java/README.md) | Base image for distribute java jars. | [![](https://img.shields.io/docker/pulls/adorsys/java.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/java) |
| [adorsys/node](node/README.md) | Base image for distribute node applications. | [![](https://img.shields.io/docker/pulls/adorsys/node.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/node) |
| [adorsys/mailout](mailout/README.md) | MTA for sending mails inside containerized applications | [![](https://img.shields.io/docker/pulls/adorsys/mailout.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/mailout) |


# Contributing

If you want to contribute new images you should done:
* The name of the subdirectory should always the same name as in the image name. For example if you want to create the
  image `adorsys/tool` the directory should be named `tool`. If your images has some flavors use subdirectories like
  `tool/<flavor>/` like `tool/alpine` and use the image tag `adorsys/tool:<flavor>` or `adorsys/tool:<version>-<flavor>`. 
  If you want you use template, take a look at https://github.com/hairyhenderson/gomplate.
* Create a executable `test.sh` and include some commands to test your images.
  if you need more complex test you should take a look to https://github.com/aelsabbahy/goss. Also a `README.md` would 
  be appreciated.
* Include your images in the `.travis.yml`. 
* Run the `gen_compose.sh` before commit your image.
* Be sure you create a new `repository` at https://hub.docker.com/r/adorsys/. The team `service` should have write
  permissions.
