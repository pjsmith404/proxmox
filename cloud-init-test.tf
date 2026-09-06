resource "proxmox_virtual_environment_file" "cloud_init_test_user_data" {
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

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_test_user_data.id
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

