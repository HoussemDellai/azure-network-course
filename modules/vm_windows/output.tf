output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}

output "vm_private_ip" {
  value = azurerm_windows_virtual_machine.vm.private_ip_address
}

output "public_ip" {
  value = var.enable_public_ip ? azurerm_public_ip.pip_vm.0.ip_address : null
}