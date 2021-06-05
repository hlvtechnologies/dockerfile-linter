# Starter Image
FROM        registry.access.redhat.com/ubi8/ubi
USER        root
RUN         adduser -u 1001 lintinguser

# Build arguments
ARG         SHELLCHECK_URL="https://github.com/koalaman/shellcheck/releases/download/v0.7.2/shellcheck-v0.7.2.linux.x86_64.tar.xz"
ARG         SHELLCHECK_DIRECTORY="shellcheck-v0.7.2"
ARG         TFLINT_URL="https://github.com/terraform-linters/tflint/releases/download/v0.29.0/tflint_linux_amd64.zip"

# Python Environment
RUN         dnf install -y \
  xz unzip python3 python3-pip python3-cryptography \
  && dnf clean all

# Ansible
RUN         pip3 install ansible-lint

# Shellcheck
ADD         ${SHELLCHECK_URL} /tmp/shellcheck.tar.xz
RUN         xz -d /tmp/shellcheck.tar.xz \
  && tar xvf /tmp/shellcheck.tar -C /tmp/ \
  && mv /tmp/${SHELLCHECK_DIRECTORY}/shellcheck /usr/local/bin/ \
  && chmod 0755 /usr/local/bin/shellcheck

# YAMLlint
RUN         pip3 install yamllint

# MarkdownLint
RUN         dnf module enable nodejs:12 -y \
  && dnf install nodejs -y \
  && npm install -g markdownlint-cli \
  && rm -rf ~/.npm \
  && markdownlint --help

# tflint
ADD         ${TFLINT_URL} /tmp/tflint.zip
RUN         cd /tmp && unzip /tmp/tflint.zip \
  && mv /tmp/tflint /usr/local/bin/tflint \
  && chmod 0755 /usr/local/bin/tflint \
  && rm -rf /tmp/tflint.zip \
  && tflint -v

# Metadata
ENV         HLV_BASE_IMAGE=hlv-linter
USER        lintinguser
ENTRYPOINT [ "/bin/sh", "-c" ]
