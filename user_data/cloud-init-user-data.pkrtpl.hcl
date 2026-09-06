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
package_update: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - echo "done" > /tmp/cloud-config.done

