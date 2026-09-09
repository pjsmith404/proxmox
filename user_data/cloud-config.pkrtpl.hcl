#cloud-config
hostname: ${hostname}

timezone: Australia/Melbourne

users:
  - name: pjls
    groups:
      - sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_authorized_key}
    sudo: ALL=(ALL) NOPASSWD:ALL

package_reboot_if_required: true
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent

write_files:
  - path: /usr/local/bin/instance-setup.sh
    permissions: "0755"
    encoding: base64
    content: ${user_script_base64}

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - /usr/local/bin/instance-setup.sh

