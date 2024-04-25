resource "azurerm_private_dns_zone" "private-dns-zone-mssql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-hub" {
  name                  = "link-vnet-hub"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-mssql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-mssql.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-spoke1" {
  name                  = "link-vnet-spoke1"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-mssql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-mssql.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-spoke2" {
  name                  = "link-vnet-spoke2"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-mssql.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-mssql.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
}