#!/usr/bin/env bash

set -euxo pipefail

# Packages required for Jelly
apt-get install -y curl nfs-common

# Fetch and install Jelly
wget https://repo.jellyfin.org/install-debuntu.sh
bash install-debuntu.sh

# Mount media
media_dir="/mnt/media"
nfs_path="192.168.1.4:/volume1/Data/Media"
mnt_string="$nfs_path    $media_dir    nfs auto,nofail,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.device-timeout=10,noatime,nolock,tcp,actimeo=1800 0 0"

mkdir "$media_dir"
echo "$mnt_string" | tee -a /etc/fstab
#
# Not sure I'll need this or not
#sudo systemctl daemon-reload
mount -a

#sudo systemctl status jellyfin
#sudo systemctl reload jellyfin
#sudo systemctl restart jellyfin
