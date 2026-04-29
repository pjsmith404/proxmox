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
Address=192.168.1.6
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

# Plex
apt -y install \
    curl \
    gpg \
    nfs-common

echo deb https://downloads.plex.tv/repo/deb public main | tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/plex.gpg
apt -y update
apt -y install plexmediaserver
mkdir /mnt/Media
mount -t nfs 192.168.1.4:/volume1/Data/Media /mnt/Media
echo "192.168.1.4:/volume1/Data/Media    /mnt/Media   nfs auto,nofail,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.device-timeout=10,noatime,nolock,tcp,actimeo=1800 0 0" | tee -a /etc/fstab
# https://linuxize.com/post/how-to-install-plex-media-server-on-ubuntu-20-04/
