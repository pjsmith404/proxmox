terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {}

resource "proxmox_vm_qemu" "static_site" {
  name        = "static-site"
  target_node = "pve"
  iso         = "local:iso/debian-12.11.0-amd64-netinst.iso"
}
