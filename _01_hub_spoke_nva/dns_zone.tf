# Private DNS Zone to configure the domain name

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "houssemdellai1.com"
  resource_group_name = azurerm_resource_group.rg-hub.name
}

# DNS Zone A record
resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = "test"
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = azurerm_private_dns_zone.dns_zone.resource_group_name
  ttl                 = 300
  records             = ["1.2.3.4"] # just example IP address
}

# DNS Zone link to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "link-vnet-hub-dns-zone"
  resource_group_name   = azurerm_private_dns_zone.dns_zone.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}