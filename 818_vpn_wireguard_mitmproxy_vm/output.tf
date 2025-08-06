output "vm_windows_public_ip" {
  value = azurerm_public_ip.pip-vm-windows.ip_address
}

output "vm_windows_private_ip" {
  value = azurerm_network_interface.nic-vm-windows.private_ip_address
}

output "vm_linux_public_ip" {
  value = azurerm_public_ip.pip-vm-linux.ip_address
}

output "vm_linux_private_ip" {
  value = azurerm_network_interface.nic-vm-linux.private_ip_address
}