#!/usr/bin/env bash

set -euxo pipefail

apt-get install -y gpg

# https://docs.ansible.com/projects/ansible-core/stable-2.22/installation_guide/installation_distros.html?utm_source=chatgpt.com#installing-ansible-on-debian
UBUNTU_CODENAME='noble'
FINGERPRINT='6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367'

wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x${FINGERPRINT}" | gpg --dearmor -o /usr/share/keyrings/ansible-archive-keyring.gpg

cat > /etc/apt/sources.list.d/ansible.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/ansible/ansible/ubuntu/
Suites: ${UBUNTU_CODENAME}
Components: main
Trusted: yes
Signed-By: /usr/share/keyrings/ansible-archive-keyring.gpg
EOF

apt-get update && apt-get install -y ansible

