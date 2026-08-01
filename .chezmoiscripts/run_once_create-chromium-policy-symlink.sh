#!/bin/bash
set -euo pipefail

EXT_DIR="$XDG_DATA_HOME/flatpak/extension/io.github.ungoogled_software.ungoogled_chromium.Policy.local/x86_64"
mkdir -p "$EXT_DIR"
ln -sfn "$HOME/.local/share/chromium-policy" "$EXT_DIR/1"
