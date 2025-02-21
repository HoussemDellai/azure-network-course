resource "azurerm_private_dns_zone" "dns_zone_appservice" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_appservice.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
