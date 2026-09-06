output "instance_ipv4" {
  description = "IPv4 addresses"
  value       = proxmox_virtual_environment_vm.cloud-init-test.ipv4_addresses
}

output "instance_ipv6" {
  description = "IPv6 addresses"
  value       = proxmox_virtual_environment_vm.cloud-init-test.ipv6_addresses
}

