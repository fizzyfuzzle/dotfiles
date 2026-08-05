#!/bin/bash
#
EXTENSIONS=(
  ms-python.python \
  charliermarsh.ruff \
  opentofu.vscode-opentofu \
  redhat.ansible \
  platformio.platformio-ide
)

# Install Extensions
for E in "${EXTENSIONS[@]}"; do
  flatpak run com.visualstudio.code --install-extension "${E}"
done
