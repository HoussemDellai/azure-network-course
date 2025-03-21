# output "vm_linux_private_ip" {
#   value = azurerm_linux_virtual_machine.vm-linux.private_ip_address
# }

# output "vm_linux_public_ip" {
#   value = azurerm_public_ip.pip-vm-linux.ip_address
# }

# output "vm_windows_private_ip" {
#   value = azurerm_windows_virtual_machine.vm-windows.private_ip_address
# }

# output "vm_windows_public_ip" {
#   value = azurerm_public_ip.pip-vm-windows.ip_address
# }

output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.pip-firewall.ip_address
}

# output "ssh-into-vm-proxy" {
#   value = "ssh ${azurerm_linux_virtual_machine.vm-linux.admin_username}@${azurerm_public_ip.pip-vm-linux.ip_address}"
# }