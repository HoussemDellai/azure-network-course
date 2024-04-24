resource "azurerm_private_dns_zone" "private-dns-zone-hub" {
  name                = "corp.azure"
  resource_group_name = azurerm_resource_group.rg-hub.name
}

resource "azurerm_private_dns_a_record" "a-record-hub" {
  name                = "addr1"
  zone_name           = azurerm_private_dns_zone.private-dns-zone-hub.name
  resource_group_name = azurerm_private_dns_zone.private-dns-zone-hub.resource_group_name
  ttl                 = 300
  records             = ["10.0.0.100"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-hub" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-hub.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-hub.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}