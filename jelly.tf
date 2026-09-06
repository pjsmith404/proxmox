resource "proxmox_virtual_environment_vm" "jelly" {
  name = "jelly"
  node_name = "pve"

  agent {
    enabled = true
  }

  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = 4
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = 6144
  }

  operating_system {
    type = "l26"
  }
}
