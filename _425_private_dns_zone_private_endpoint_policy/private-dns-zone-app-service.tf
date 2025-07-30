resource "azurerm_private_dns_zone" "private-dns-zone-app-service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-dns-zone-app-service" {
  name                  = "link-vnet-dns-zone-app-service"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-app-service.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
