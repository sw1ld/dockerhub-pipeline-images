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
