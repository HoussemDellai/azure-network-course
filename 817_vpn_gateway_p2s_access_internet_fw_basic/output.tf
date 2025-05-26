output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.pip-firewall-transit.ip_address
}

output "vm_nva_public_ip" {
  value = azurerm_public_ip.pip-vm-nva.ip_address
}

output "vm_nva_private_ip" {
  value = azurerm_network_interface.nic-vm-nva.private_ip_address
}