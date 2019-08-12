#!/usr/bin/env bats

@test "run nginx version" {
  run docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -V
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ nginx\ version:\ nginx/1 ]]
}

@test "run nginx config test" {
  run docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -t
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ syntax\ is\ ok ]]
  [[ "${lines[1]}" =~ test\ is\ successful ]]
}

@test "run nginx config test with NGINX_DISABLE_ACCESS_LOG=true" {
  run docker run -eNGINX_DISABLE_ACCESS_LOG=true --rm "${DOCKER_IMAGE}:${TAG}" nginx -t
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ syntax\ is\ ok ]]
  [[ "${lines[1]}" =~ test\ is\ successful ]]
}

@test "show current user with random uid (openshift mode)" {
  run docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "default" ]
}

@test "run nginx config test with random uid (openshift mode)" {
  run docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" nginx -t
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ syntax\ is\ ok ]]
  [[ "${lines[1]}" =~ test\ is\ successful ]]
}

@test "test /docker-entrypoint.d/*.sh" {
  run docker run --rm -v "$PWD/../../.tests/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh "${DOCKER_IMAGE}:${TAG}" nginx -t
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "TEST-ENTRYPOINT-HOOK-WORKS!" ]
  [[ "${lines[1]}" =~ syntax\ is\ ok ]]
  [[ "${lines[2]}" =~ test\ is\ successful ]]
}

@test "run nginx and get an website" {
  run docker run --rm --name nginx -u 1000090000:0 -d -p8080:8080 -v "$PWD/../../.tests/nginx/index.html":/usr/share/nginx/html/index.html "${DOCKER_IMAGE}:${TAG}"
  [ "$status" -eq 0 ]

  run curl -s localhost:8080
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "OK" ]

  run docker logs nginx
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ index\.html ]]

  run docker rm -f nginx
  [ "$status" -eq 0 ]
}
