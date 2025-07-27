output "vm_nva_public_ip" {
  value = azurerm_public_ip.pip-vm-nva.ip_address
}

output "vm_nva_private_ip_trusted" {
  value = azurerm_network_interface.nic-vm-nva-trusted.private_ip_address
}

output "vm_nva_private_ip_untrusted" {
  value = azurerm_network_interface.nic-vm-nva-untrusted.private_ip_address
}
