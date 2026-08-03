{{- if .workstation -}}
#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

EXT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/extension/io.github.ungoogled_software.ungoogled_chromium.Policy.local/$(uname -m)"
mkdir -p "${EXT_DIR}"
ln -sfn "$HOME/.local/share/chromium-policy" "${EXT_DIR}/1"
{{- end -}}
