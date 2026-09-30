resource "proxmox_virtual_environment_file" "ansible_config" {
  content_type = "snippets"
  node_name    = "pve"
  datastore_id = "local"

  source_raw {
    data = templatefile("${abspath(path.root)}/user_data/cloud-config.pkrtpl.hcl", {
      hostname           = "ansible"
      ssh_authorized_key = trimspace(data.local_file.ssh_public_key.content)
      ansible_pub_key = var.ansible_pub_key
      user_script_base64 = filebase64("${abspath(path.root)}/user_data/ansible.sh")
    })
    file_name = "cloud-config-ansible.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "ansible" {
  name = "ansible"
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

    user_data_file_id = proxmox_virtual_environment_file.ansible_config.id
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
