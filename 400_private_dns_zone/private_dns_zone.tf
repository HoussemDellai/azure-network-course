resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "internal.corp"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "a-record" {
  name                = "app1"
  zone_name           = azurerm_private_dns_zone.private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = ["10.0.0.100"]
}

resource "azurerm_private_dns_cname_record" "cname-record" {
  name                = "app2"
  zone_name           = azurerm_private_dns_zone.private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = "mycompany.com"
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
}