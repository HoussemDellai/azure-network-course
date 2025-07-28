resource "azurerm_private_dns_zone" "dns-zone-key-vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-dns-zone-key-vault" {
  name                  = "link-vnet-dns-zone-key-vault"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone-key-vault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
