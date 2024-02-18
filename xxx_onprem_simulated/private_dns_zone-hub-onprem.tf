resource "azurerm_private_dns_zone" "private-dns-zone-onprem" {
  name                = "corp.internal"
  resource_group_name = azurerm_resource_group.rg-onprem.name
}

resource "azurerm_private_dns_a_record" "a-record-onprem" {
  name                = "addr1"
  zone_name           = azurerm_private_dns_zone.private-dns-zone-onprem.name
  resource_group_name = azurerm_private_dns_zone.private-dns-zone-onprem.resource_group_name
  ttl                 = 300
  records             = ["172.16.0.100"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-onprem" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-onprem.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-onprem.name
  virtual_network_id    = azurerm_virtual_network.vnet-onprem.id
}