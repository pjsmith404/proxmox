#!/bin/bash

set -ex

sudo apt -y update
sudo apt -y upgrade
sudo apt -y install \
    curl \
    gpg \
    nfs-common
sudo apt -y remove ifupdown
sudo systemctl enable systemd-resolved
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-resolved
sudo systemctl start systemd-networkd

sudo mkdir /mnt/temp
sudo mount -t nfs 192.168.1.4:/volume1/Data/PJLS/repos/ /mnt/temp
