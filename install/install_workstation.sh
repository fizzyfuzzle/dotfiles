#!/usr/bin/env bash

# Do not install recommended packages
grep -q '^Recommends=false' /etc/rpm-ostreed.conf || \
    run0 sed -i 's/^#\?Recommends=.*/Recommends=false/' /etc/rpm-ostreed.conf

# Add Brave Repository
[ ! -f "/etc/yum.repos.d/brave-browser.repo" ] && \
    run0 curl --tlsv1.3 -fsSLo /etc/yum.repos.d/brave-browser.repo \
    https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Add Brave Policies
[ ! -f "/etc/brave/policies/managed/brave.json" ] && \
    run0 mkdir -p /etc/brave/policies/managed && \
    run0 cp brave.json /etc/brave/policies/managed/

# Overlay Additional Packages
rpm-ostree install --idempotent --assumeyes \
    brave-browser \
    vim-enhanced \
    zsh

# Overlay Remove Firefox
#command -v firefox &>/dev/null && \
#    rpm-ostree override remove firefox firefox-langpacks

# Disable System Services
systemctl mask \
    bluetooth.service \
    cups.service cups.socket cups.path \
    ModemManager.service \
    sddm.service \
    systemd-coredump.socket \
    systemd-oomd.service systemd-oomd.socket

# Disable User Services
systemctl --user mask \
    app-blueman@autostart.service \
    app-geoclue\\x2ddemo\\x2dagent@autostart.service \
    at-spi-dbus-bus.service \
    blueman-applet.service \
    blueman-manager.service \
    mpris-proxy.service \
    obex.service

# Update GRUB timeout
echo "set timeout=0" | run0 tee /boot/grub2/user.cfg

# Reboot (Only needed on first run)
command -v zsh &>/dev/null || systemctl reboot

# Change Shell to ZSH
[ "$SHELL" != "$(command -v zsh)" ] && chsh --shell "$(command -v zsh)"

# Install Age
[ ! -f "$HOME/bin/age" ] && \
    curl --tlsv1.3 -fsSL "https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-linux-amd64.tar.gz" | \
    tar --strip-components=1 -zxf - -C "$HOME/bin"
[ ! -f "$HOME/bin/age-plugin-yubikey" ] && \
    curl --tlsv1.3 -fsSL "https://github.com/str4d/age-plugin-yubikey/releases/download/v0.5.0/age-plugin-yubikey-v0.5.0-x86_64-linux.tar.gz" | \
    tar --strip-components=1 -zxf - -C "$HOME/bin"

# Install Papirus Icon Theme
[ ! -d "$HOME/.icons" ] && \
    curl --tlsv1.3 -fsSL https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

# Add Flathub
flatpak remote-add --user --if-not-exists \
    flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
flatpak install --user --assumeyes \
    com.github.tchx84.Flatseal \
    io.mpv.Mpv \
    org.keepassxc.KeePassXC \
    org.libreoffice.LibreOffice \
    com.visualstudio.code

# Install Toolbox Packages
# toolbox run sudo dnf install --setopt install_weak_deps=false --refresh --assumeyes \
#    chezmoi qrencode steghide zsh

# Set Wireplumber Profile [disable mic]
# pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo

