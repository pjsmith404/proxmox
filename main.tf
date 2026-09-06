terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.112.0"
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

data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}

resource "proxmox_virtual_environment_vm" "cloud-init-test" {
  name      = "cloud-init-test"
  node_name = "pve"

  agent {
    enabled = true
  }

  stop_on_destroy = true

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id
  }

  memory {
    dedicated = 1024
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.debian_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
}

resource "proxmox_download_file" "debian_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve"
  url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  content_type = "snippets"
  node_name    = "pve"
  datastore_id = "local"

  source_raw {
    data = templatefile("${abspath(path.root)}/user_data/cloud-init-user-data.pkrtpl.hcl", {
      hostname           = "cloud-init-test"
      ssh_authorized_key = trimspace(data.local_file.ssh_public_key.content)
    })
    file_name = "cloud-init-user-data.yaml"
  }
}

output "instance_ipv4" {
  description = "IPv4 addresses"
  value       = proxmox_virtual_environment_vm.cloud-init-test.ipv4_addresses
}

output "instance_ipv6" {
  description = "IPv6 addresses"
  value       = proxmox_virtual_environment_vm.cloud-init-test.ipv6_addresses
}
