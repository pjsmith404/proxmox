terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.104.0"
    }
  }
}

variable "pve_endpoint" {
  type        = string
  description = "The PVE endpoint to connect to (eg https://192.168.1.1:8006)"
}

variable "pve_user" {
  type        = string
  description = "The PVE user to use against the API"
}

variable "pve_password" {
  type        = string
  description = "The PVE password to use against the API"
}

provider "proxmox" {
  endpoint = var.pve_endpoint
  username = var.pve_user
  password = var.pve_password
  insecure = true
}


data "proxmox_file" "debian_12_iso" {
  node_name    = "pve"
  datastore_id = "local"
  content_type = "iso"
  file_name    = "debian-12.11.0-amd64-netinst.iso"
}

resource "proxmox_virtual_environment_vm" "static_site" {
  name      = "static-site"
  node_name = "pve"


  memory {
    dedicated = 1024
  }

  cdrom {
    file_id = data.proxmox_file.debian_12_iso.id
  }
}
