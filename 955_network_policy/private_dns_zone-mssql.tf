resource "azurerm_private_dns_zone" "private-dns-zone-mssql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-mssql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-mssql.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}