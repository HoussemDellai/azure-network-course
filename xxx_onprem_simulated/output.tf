output "vm-linux-hub" {
  value = azurerm_linux_virtual_machine.vm-hub.private_ip_address
}

output "vm-linux-spoke1" {
  value = azurerm_linux_virtual_machine.vm-spoke1.private_ip_address
}

output "vm-linux-spoke2" {
  value = azurerm_linux_virtual_machine.vm-spoke2.private_ip_address
}

output "vm-linux-onprem" {
  value = azurerm_linux_virtual_machine.vm-onprem.private_ip_address
}