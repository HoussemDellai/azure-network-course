output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

output "hub_vnet" {
  value = {
    id      = azurerm_virtual_network.vnet-hub.id
    name    = azurerm_virtual_network.vnet-hub.name
    rg_name = azurerm_virtual_network.vnet-hub.resource_group_name
  }
}
