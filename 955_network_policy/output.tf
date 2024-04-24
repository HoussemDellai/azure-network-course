output "vm-linux-hub-ip" {
  value = azurerm_linux_virtual_machine.vm-hub.private_ip_address
}

output "vm-linux-spoke1-ip" {
  value = azurerm_linux_virtual_machine.vm-spoke1.private_ip_address
}

output "vm-linux-spoke2-ip" {
  value = azurerm_linux_virtual_machine.vm-spoke2.private_ip_address
}

output "dns-zone-hub" {
  value = azurerm_private_dns_zone.private-dns-zone-hub.name
}

output "mssql-server-fqdn" {
  value = azurerm_mssql_server.mssql-server.fully_qualified_domain_name
}