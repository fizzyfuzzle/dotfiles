#!/bin/bash
#
# Install VSCode Extensions
#
EXTENSIONS=(
  hashicorp.terraform \
  ms-python.isort \
  ms-python.flake8 \
  ms-python.python \
  ms-vscode-remote.remote-ssh \
  pkief.material-icon-theme \
  redhat.ansible
)

# Check if CODE is installed
command -v code &>/dev/null || {
  echo "VSCODE NOT INSTALLED ..."
  exit 1
}

# Install Extensions
for E in "${EXTENSIONS[@]}"; do
  code --install-extension "${E}"
done
