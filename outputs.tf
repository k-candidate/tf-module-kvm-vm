output "ip_address" {
  description = "The IP address of the created VM"
  value       = libvirt_domain.vm.network_interface[0].addresses[0]
}