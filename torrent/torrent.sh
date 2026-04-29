#!/bin/bash
set -ex

sudo su

# Base packages
apt -y update
apt -y upgrade

# Network configuration
apt -y remove ifupdown
systemctl enable systemd-resolved
systemctl enable systemd-networkd
systemctl start systemd-resolved
systemctl start systemd-networkd
cat > /etc/systemd/network/static.network <<EOF
[Match]
Name=en*

[Network]
Address=192.168.1.7
Gateway=192.168.1.1
DNS=192.168.1.1
EOF

# Unattended Upgrades
apt -y install \
    unattended-upgrades \
    apt-listchanges

cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Docker - https://docs.docker.com/engine/install/debian/
apt -y install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt -y update

apt -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

usermod -aG docker pjls
