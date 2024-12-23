#!/bin/bash
#
# Install VSCode Extensions
#
EXTENSIONS=(
  pkief.material-icon-theme \
  ms-vscode-remote.remote-ssh \
  ms-vscode.remote-explorer \
  ms-python.python \
  ms-python.vscode-pylance \
  ms-python.debugpy \
  ms-python.isort \
  hashicorp.terraform \
  redhat.ansible \
  redhat.vscode-yaml
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
