#!/bin/bash
set -ex

sudo su

# App updates
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
Address=192.168.1.2
Gateway=192.168.1.1
DNS=192.168.1.1
EOF

# Unattended upgrades
apt -y install \
    unattended-upgrades \
    apt-listchanges

cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Configure DNS
apt -y install \
    bind9 \
    bind9-doc

