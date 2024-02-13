output "vm_linux_proxy_mitm_private_ip" {
  value = azurerm_linux_virtual_machine.vm-proxy.private_ip_address
}

output "vm_linux_proxy_mitm_public_ip" {
  value = azurerm_public_ip.pip-vm-proxy.ip_address
}

output "vm_linux_proxy_squid_private_ip" {
  value = azurerm_linux_virtual_machine.vm-proxy-squid.private_ip_address
}

output "vm_linux_proxy_squid_public_ip" {
  value = azurerm_public_ip.pip-vm-proxy-squid.ip_address
}

# output "firewall_private_ip" {
#   value = azurerm_firewall.firewall.private_ip_address
# }

output "ssh-into-vm-proxy" {
  value = "ssh ${azurerm_linux_virtual_machine.vm-proxy.admin_username}@${azurerm_public_ip.pip-vm-proxy.ip_address}"
}