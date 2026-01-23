#!/usr/bin/env bash

# Check internet
ping -c 1 -W 1 1.1.1.1 &>/dev/null || exit 1

# Do not install recommended packages
grep -q '^Recommends=false' /etc/rpm-ostreed.conf || \
    sudo sed -i 's/^#\?Recommends=.*/Recommends=false/' /etc/rpm-ostreed.conf

# Add Brave Repository
[ ! -f "/etc/yum.repos.d/brave-browser.repo" ] && \
    sudo curl --tlsv1.3 -fsSLo /etc/yum.repos.d/brave-browser.repo \
    https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Add Brave Policies
[ ! -f "/etc/brave/policies/managed/brave.json" ] && \
    sudo mkdir -pZ /etc/brave/policies/managed && \
    sudo cp brave.json /etc/brave/policies/managed/

# Overlay Additional Packages
rpm-ostree install --idempotent --assumeyes \
    brave-browser \
    iwd \
    vim-enhanced \
    zsh

# Overlay Remove Firefox
#command -v firefox &>/dev/null && \
#    rpm-ostree override remove firefox firefox-langpacks

# Disable System Services
sudo systemctl mask \
    bluetooth.service \
    cups.service cups.socket cups.path \
    ModemManager.service \
    sddm.service \
    systemd-coredump.socket \
    systemd-oomd.service systemd-oomd.socket \
    wpa_supplicant.service

# Disable User Services
systemctl --user mask \
    app-blueman@autostart.service \
    app-geoclue\\x2ddemo\\x2dagent@autostart.service \
    blueman-applet.service \
    blueman-manager.service \
    mpris-proxy.service \
    obex.service

# Switch NetworkManager to IWD
[ ! -f "/etc/NetworkManager/conf.d/iwd.conf" ] && \
    sudo mkdir -pZ /etc/NetworkManager/conf.d && \
    echo "[device]
wifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/iwd.conf

# Firewalld
sudo firewall-cmd --permanent \
    --remove-service=ssh \
    --add-port=53317/udp --add-port=53317/tcp

# Update GRUB timeout
echo "set timeout=0" | sudo tee /boot/grub2/user.cfg

# Reboot (Only needed on first run)
command -v zsh &>/dev/null || systemctl reboot

# Change Shell to ZSH
[ "$SHELL" != "$(command -v zsh)" ] && chsh --shell "$(command -v zsh)"

# Enable Kanshi
systemctl --user enable kanshi.service

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
    org.localsend.localsend_app \
    com.visualstudio.code

# Cleanup
rm -rf .bash_profile .bashrc .bash_logout .bash_history \
    Desktop Music Pictures Public Templates Videos

# Create Default Toolbox + Packages
toolbox create --assumeyes && \
    toolbox run sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    toolbox run sudo dnf install --setopt install_weak_deps=false --refresh --assumeyes \
        ansible chezmoi pcsc-lite-libs qrencode steghide terraform zsh

# Apply Chezmoi
[ ! -d "$HOME/.local/share/chezmoi" ] && \
    toolbox run chezmoi init --apply fizzyfuzzle

# Add User to dialout group
if ! grep -q "^dialout:" /etc/group; then
    getent group | grep dialout | sudo tee -a /etc/group
fi
sudo usermod -aG dialout marco

# Set Wireplumber Profile [disable mic]
# > pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo
