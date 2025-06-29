resource "azurerm_private_dns_zone" "dns-zone-storage-account" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-link-storage-account" {
  name                  = "dns-zone-link-storage-account"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone-storage-account.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
}
