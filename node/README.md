[![](https://img.shields.io/docker/pulls/adorsys/node.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/node/)
[![](https://img.shields.io/docker/stars/adorsys/node.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/adorsys/node/)

# adorsys/node

https://hub.docker.com/r/adorsys/node/

## Description

Provides node. Should be used for runtime containers.

## Example Dockerfile

```dockerfile
FROM adorsys/node:10

EXPOSE 3000

COPY . .

CMD ["node", "server.js"]
```

If want to exclude files from your docker image, e.g. documentation, 
use a [`.dockerignore`](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file.

## Entrypoint hooks

If you need to run addition logic on container start just copy your shell script to `/docker-entrypoint.d/`.

## Tags

| Name | Description | Size |
| ---- | ----------- | ---- |
| `8` | CentOS based image Node 8 | ![](https://img.shields.io/microbadger/image-size/adorsys/node/8.svg?style=flat-square) |
| `11` | CentOS based image Node 10 | ![](https://img.shields.io/microbadger/image-size/adorsys/node/10.svg?style=flat-square) |
| `8-alpine` | Alpine based image Node 8 | ![](https://img.shields.io/microbadger/image-size/adorsys/node/8-alpine.svg?style=flat-square) |
| `11-alpine` | Alpine based image Node 10 | ![](https://img.shields.io/microbadger/image-size/adorsys/node/10-alpine.svg?style=flat-square) |
