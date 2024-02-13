resource "azurerm_private_dns_zone" "private-dns-zone-spoke" {
  name                = "spoke.internal"
  resource_group_name = azurerm_resource_group.rg-spoke.name
}

resource "azurerm_private_dns_a_record" "a-record-spoke" {
  name                = "vm2"
  zone_name           = azurerm_private_dns_zone.private-dns-zone-spoke.name
  resource_group_name = azurerm_private_dns_zone.private-dns-zone-spoke.resource_group_name
  ttl                 = 300
  records             = ["10.1.0.200"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-spoke" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-spoke.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-spoke.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}