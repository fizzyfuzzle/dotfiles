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

# Stage updates automatically
grep -q '^AutomaticUpdatePolicy=stage' /etc/rpm-ostreed.conf || \
    sudo sed -i 's/^#\?AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
sudo systemctl enable --now rpm-ostreed-automatic.timer

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
    accounts-daemon.service \
    avahi-daemon.service avahi-daemon.socket \
    bluetooth.service \
    bolt.service \
    cups.service cups.socket cups.path \
    geoclue.service \
    gssproxy.service \
    ModemManager.service \
    NetworkManager-wait-online.service \
    passim.service \
    sddm.service \
    systemd-coredump.socket \
    systemd-homed.service systemd-homed-activate.service \
    systemd-oomd.service systemd-oomd.socket \
    tuned.service tuned-ppd.service \
    upower.service \
    wpa_supplicant.service

# Add User to dialout group
grep -q '^dialout:' /etc/group || getent group dialout | sudo tee -a /etc/group
sudo usermod -aG dialout "$(whoami)"

# Podman network-online fix
# https://github.com/containers/podman/issues/24796
sudo ln -sf /usr/lib/systemd/system/network-online.target \
    /etc/systemd/system/multi-user.target.wants/network-online.target

# Toolbox needs /run/avahi-daemon/socket to exist even with avahi masked
# https://github.com/containers/toolbox/issues/1590
file="/etc/tmpfiles.d/toolbox-avahi-workaround.conf"
if ! sudo test -f "$file"; then
    sudo tee "$file" > /dev/null <<'EOF'
d /run/avahi-daemon 0755 root root -
f /run/avahi-daemon/socket 0666 root root -
EOF
    sudo systemd-tmpfiles --create "$file"
fi

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

# Set ptrace_scope for Chromium sandboxing
echo 'kernel.yama.ptrace_scope = 1' | sudo tee /etc/sysctl.d/99-yama-ptrace.conf
sudo sysctl --system

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
sudo firewall-cmd --reload

# Update GRUB timeout
file="/boot/grub2/user.cfg"
sudo tee "$file" > /dev/null <<'EOF'
set timeout=0
EOF

# Bootstrap Chezmoi (clone + init)
# - manually 'chezmoi apply' after reboot
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT

    curl -fsSL -o "$tmpdir/chezmoi.tar.gz" \
        "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_amd64.tar.gz"
    echo "$CHEZMOI_SHA256  $tmpdir/chezmoi.tar.gz" | sha256sum --check -

    mkdir -p ~/.local/bin
    tar -xzf "$tmpdir/chezmoi.tar.gz" -C ~/.local/bin chezmoi
    chezmoi init "$CHEZMOI_USER"
fi

# Reboot (Only needed on first run)
command -v zsh &>/dev/null || systemctl reboot
