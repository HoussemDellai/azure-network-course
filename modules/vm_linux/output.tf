output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "vm_private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "nic_id" {
  value = azurerm_network_interface.nic_vm.id
}

output "nic_configuration_name" {
  value = azurerm_network_interface.nic_vm.ip_configuration.0.name
}