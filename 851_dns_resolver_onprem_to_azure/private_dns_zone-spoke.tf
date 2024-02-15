#-------------------------------------------------------------
# This Private DNS Zone will be resolvable only from Spoke VNET as it is attached to it.
# Hub VNET could not resolve this Private DNS Zone through DNS Private Resolver.
# DNS Private Resolver resolves only Private DNS Zones 
# that are attached to the VNET where the DNS Private Resolver is provisioned.
#-------------------------------------------------------------

resource "azurerm_private_dns_zone" "private-dns-zone-spoke" {
  name                = "spoke.corp.azure"
  resource_group_name = azurerm_resource_group.rg-spoke.name
}

resource "azurerm_private_dns_a_record" "a-record-spoke" {
  name                = "addr1"
  zone_name           = azurerm_private_dns_zone.private-dns-zone-spoke.name
  resource_group_name = azurerm_private_dns_zone.private-dns-zone-spoke.resource_group_name
  ttl                 = 300
  records             = ["1.2.3.5"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-spoke" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-spoke.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-spoke.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
}