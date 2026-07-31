#!/usr/bin/env bash
set -euo pipefail
#
CHEZMOI_VERSION="2.71.1"
CHEZMOI_SHA256="e1fb16c962644d57f4d451c324aa86163d00faf5d035500f41fb48943a66dfed"
CHEZMOI_USER="fizzyfuzzle"
#
# Check internet
ping -c 1 -W 1 1.1.1.1 &>/dev/null || exit 1

# Do not install recommended packages
grep -q '^Recommends=false' /etc/rpm-ostreed.conf || \
    sudo sed -i 's/^#\?Recommends=.*/Recommends=false/' /etc/rpm-ostreed.conf

# Overlay Additional Packages
rpm-ostree install --idempotent --assumeyes \
    iwd \
    vim-enhanced \
    zsh

# Overlay Remove Firefox
command -v firefox &>/dev/null && \
    rpm-ostree override remove firefox firefox-langpacks

# Disable System Services
sudo systemctl mask \
    avahi-daemon.service avahi-daemon.socket \
    bluetooth.service \
    cups.service cups.socket cups.path \
    geoclue.service \
    ModemManager.service \
    passim.service \
    sddm.service \
    systemd-coredump.socket \
    systemd-oomd.service systemd-oomd.socket \
    wpa_supplicant.service

# Disable User Services
systemctl --user mask \
    app-blueman@autostart.service \
    app-geoclue\\x2ddemo\\x2dagent@autostart.service \
    app-nm\\x2dapplet@autostart.service \
    blueman-applet.service \
    blueman-manager.service \
    mpris-proxy.service \
    obex.service

# Podman network-online fix
# https://github.com/containers/podman/issues/24796
sudo ln -sf /usr/lib/systemd/system/network-online.target \
    /etc/systemd/system/multi-user.target.wants/network-online.target

# Switch NetworkManager to IWD
file="/etc/NetworkManager/conf.d/iwd.conf"
if ! sudo test -f "$file"; then
    sudo mkdir -pZ "$(dirname "$file")"
    sudo tee "$file" > /dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
fi

# Add run0 Polkit rule
file="/etc/polkit-1/rules.d/90-run0-wheel.rules"
if ! sudo test -f "$file"; then
    sudo tee "$file" > /dev/null <<'EOF'
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units") {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.AUTH_ADMIN_KEEP;
        }
    }
});
EOF
    sudo chmod 644 "$file"
fi

# Firewalld
sudo firewall-cmd --permanent --zone=home --add-source=192.168.88.0/24
sudo firewall-cmd --permanent --zone=home \
    --remove-service=mdns \
    --remove-service=samba-client
sudo firewall-cmd --permanent --zone=home --add-service=syncthing
sudo firewall-cmd --permanent --zone=home --remove-forward
#
sudo firewall-cmd --permanent --zone=public \
    --remove-service=mdns \
    --remove-service=ssh
sudo firewall-cmd --permanent --zone=public --remove-forward

# Update GRUB timeout
file="/boot/grub2/user.cfg"
sudo tee "$file" > /dev/null <<'EOF'
set timeout=0
EOF

# Reboot (Only needed on first run)
command -v zsh &>/dev/null || systemctl reboot

# Change Shell to ZSH
[ "$SHELL" != "$(command -v zsh)" ] && chsh --shell "$(command -v zsh)"

# Enable Kanshi
systemctl --user enable kanshi.service

# Add Flathub
flatpak remote-add --user --if-not-exists \
    flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
flatpak install --user --assumeyes \
    com.calibre_ebook.calibre \
    com.github.tchx84.Flatseal \
    io.github.ungoogled_software.ungoogled_chromium \
    io.mpv.Mpv \
    org.keepassxc.KeePassXC \
    org.libreoffice.LibreOffice \
    com.visualstudio.code

# Cleanup
rm -rf .bash_profile .bashrc .bash_logout .bash_history \
    Desktop Music Pictures Public Templates Videos

# Create Default Toolbox + Packages
toolbox create --assumeyes && \
    toolbox run sudo dnf install --setopt install_weak_deps=false --refresh --assumeyes \
        ansible offlineimap opentofu pcsc-lite-libs python3-dateutil python3-requests qrencode steghide zsh

# Bootstrap Chezmoi
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT

    curl -fsSL -o "$tmpdir/chezmoi.tar.gz" \
        "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_amd64.tar.gz"
    echo "$CHEZMOI_SHA256  $tmpdir/chezmoi.tar.gz" | sha256sum --check -

    mkdir -p ~/.local/bin
    tar -xzf "$tmpdir/chezmoi.tar.gz" -C ~/.local/bin chezmoi
    chezmoi init --apply "$CHEZMOI_USER"
fi

# Add User to dialout group
if ! grep -q "^dialout:" /etc/group; then
    getent group | grep dialout | sudo tee -a /etc/group
fi
sudo usermod -aG dialout $(whoami)
