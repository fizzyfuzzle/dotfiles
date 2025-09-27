#!/usr/bin/env bash

# Do not install recommended packages
run0 sed -i 's/^#\?Recommends=.*/Recommends=false/' /etc/rpm-ostreed.conf

# Add Brave Repository
run0 curl --tlsv1.3 -fsSLo /etc/yum.repos.d/brave-browser.repo \
    https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Overlay Additional Packages
rpm-ostree install --idempotent --assumeyes \
    brave-browser \
    neovim \
    papirus-icon-theme \
    wayvnc \
    wireguard-tools \
    zsh

# Overlay Remove Firefox
command -v firefox &>/dev/null \
    && rpm-ostree override remove firefox firefox-langpacks

# Disable System Services
systemctl mask \
    bluetooth.service \
    cups.service cups.socket cups.path \
    ModemManager.service \
    sddm.service \
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
if [ "$SHELL" != "$(command -v zsh)" ]; then
    chsh --shell "$(command -v zsh)"
fi

# Set Theme
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface icon-theme Papirus

# Add Flathub
flatpak remote-add --user --if-not-exists \
    flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
flatpak install --user --assumeyes \
    com.github.tchx84.Flatseal \
    org.keepassxc.KeePassXC \
    org.libreoffice.LibreOffice \
    com.visualstudio.code

