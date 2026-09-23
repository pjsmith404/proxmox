output "jelly_ipv6" {
  description = "IPv6 addresses"
  value       = proxmox_virtual_environment_vm.jelly.ipv6_addresses[1]
}

output "nginx_ipv6" {
  description = "IPv6 addresses"
  value       = proxmox_virtual_environment_vm.nginx.ipv6_addresses[1]
}

output "cloud_init_test_ipv6" {
  description = "IPv6 addresses"
  value       = proxmox_virtual_environment_vm.cloud-init-test.ipv6_addresses[1]
}

