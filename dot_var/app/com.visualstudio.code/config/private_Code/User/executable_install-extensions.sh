#!/bin/bash
#
EXTENSIONS=(
  ms-python.isort \
  ms-python.flake8 \
  ms-python.python \
  ms-vscode-remote.remote-ssh \
  platformio.platformio-ide \
  redhat.ansible
)

# Install Extensions
for E in "${EXTENSIONS[@]}"; do
  flatpak run com.visualstudio.code --install-extension "${E}"
done
