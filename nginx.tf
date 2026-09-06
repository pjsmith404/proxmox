resource "proxmox_virtual_environment_vm" "nginx" {
  name = "nginx"
  node_name = "pve"

  agent {
    enabled = true
  }

  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = 1
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = 1024
  }

  operating_system {
    type = "l26"
  }
}
