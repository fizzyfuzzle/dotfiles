#!/bin/bash
#
CODE="flatpak run com.visualstudio.code"
EXTENSIONS=(
  hashicorp.terraform \
  ms-python.isort \
  ms-python.flake8 \
  ms-python.python \
  ms-vscode-remote.remote-ssh \
  redhat.ansible
)

# Install Extensions
for E in "${EXTENSIONS[@]}"; do
  "${CODE}" --install-extension "${E}"
done
