#!/usr/bin/env bash

set -euxo pipefail

apt-get install -y \
	certbot \
	nfs-common \
	nginx \
	python3-certbot-nginx

# Mount config
media_dir="/mnt/config"
nfs_path="192.168.1.4:/volume1/Data/configs"

mkdir "$media_dir"
mount -t nfs "$nfs_path" "$media_dir"

# Setup nginx
nginx_dir="/etc/nginx"

# TODO: Figure out certbot bootstrap on new host.
# Got ourselves a chicken\egg scenario with DNS config and pointing at the new server
# Certbot
certbot certonly --nginx --agree-tos -d syphilicious.net
certbot certonly --nginx --agree-tos -d jelly.syphilicious.net

# Configure sites
cp "$media_dir/nginx/*" "$nginx_dir/sites-available/"
ln -s "$nginx_dir/sites-available/jellyfin" "$nginx_dir/sites-enabled/jellyfin"
ln -s "$nginx_dir/sites-available/base" "$nginx_dir/sites-enabled/base"
rm "$nginx_dir/sites-enabled/default"

systemctl reload nginx

# Unmount once all done
umount "$media_dir"
