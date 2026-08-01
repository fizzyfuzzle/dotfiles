#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

container="fedora-toolbox-$(rpm -E %fedora)"

if podman container exists "$container"; then
    if [ "$(podman container inspect --format '{{.State.Running}}' "$container")" = "true" ]; then
        echo "toolbox-refresh: $container is currently in use, skipping this run" >&2
        exit 0
    fi
    toolbox rm "$container"
fi

toolbox create --assumeyes
toolbox run sudo dnf install --setopt install_weak_deps=false --refresh --assumeyes --quiet \
    ansible offlineimap opentofu pcsc-lite-libs python3-dateutil python3-requests qrencode steghide zsh
