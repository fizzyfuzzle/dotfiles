#!/usr/bin/env bash

# Do not install recommended packages
echo -e "[main]\ninstall_weak_deps=False" | sudo tee /etc/dnf/dnf.conf

# Install Packages
sudo dnf install --assumeyes \
    age \
    chezmoi \
    cryptsetup \
    mkfs.ext4 \
    qrencode \
    steghide \
    wl-clipboard \
    zsh
