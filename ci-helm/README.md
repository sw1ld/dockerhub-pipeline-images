# Gitlab

```yaml
lint:
  stage: lint
  before_script:
  - eval $(gpg-agent --daemon --quiet --allow-preset-passphrase)
  - echo "${GPG_KEY}" | gpg --quiet --batch --import -
  - export KEYID=$(echo "${GPG_KEY}" | gpg --with-colons - | grep '^ssb:' | cut -d':' -f 5 | tail -c 9)
  - /usr/libexec/gpg-preset-passphrase --preset --passphrase ${KEYID}
  script:
  - helm-wrapper lint . -f secrets/dev/secrets.yaml
  after_script:
  - pkill gpg-agent
```
