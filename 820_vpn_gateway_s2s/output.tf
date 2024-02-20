output "vm-linux-hub-ip" {
  value = azurerm_linux_virtual_machine.vm-hub.private_ip_address
}

output "vm-linux-onprem-ip" {
  value = azurerm_linux_virtual_machine.vm-onprem.private_ip_address
}