#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

container="fedora-toolbox-$(rpm -E %fedora)"

podman container exists "$container" && toolbox rm "$container"

toolbox create --assumeyes
toolbox run sudo dnf install --setopt install_weak_deps=false --refresh --assumeyes --quiet \
    ansible offlineimap opentofu pcsc-lite-libs python3-dateutil python3-requests qrencode steghide zsh
