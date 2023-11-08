output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}

output "vm_private_ip" {
  value = azurerm_windows_virtual_machine.vm.private_ip_address
}