# HLV Linting Image

## What does it do?

- CI/CD Linters
  - [markdownlint](https://github.com/DavidAnson/markdownlint)
  - [ShellCheck](https://github.com/koalaman/shellcheck)
  - [yamllint](https://github.com/adrienverge/yamllint)
  - [TFLint](https://github.com/terraform-linters/tflint)

## How do I use this image?

In your `.gitlab-ci.yml`, call this image and use the tools with the appropriate arguments.

```yaml
lint:
  image: registry.hlv.inside/cicd-tools/hlv-linter:latest
  stage: lint
  script:
    - yamllint /${CI_PROJECT_PATH}/*.yaml /${CI_PROJECT_PATH}/*.yml
  tags:
    - kubernetes
  only:
    - merge_requests
  allow_failure: true
```
