#!/bin/bash
#
EXTENSIONS=(
  ms-python.python \
  ms-pyright.pyright \
  charliermarsh.ruff \
  opentofu.vscode-opentofu \
  redhat.ansible \
  platformio.platformio-ide
)

# Install Extensions
for E in "${EXTENSIONS[@]}"; do
  flatpak run com.visualstudio.code --install-extension "${E}"
done

EXTENSIONS=(
  ms-python.vscode-pylance \
  ms-python.debugpy
)

# Remove Extensions
for E in "${EXTENSIONS[@]}"; do
  flatpak run com.visualstudio.code --uninstall-extension "${E}" 2>/dev/null || true
done

