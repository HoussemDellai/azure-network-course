resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "internal.corp"
  resource_group_name = azurerm_resource_group.rg-consumer.name
}

resource "azurerm_private_dns_a_record" "a-record" {
  name                = "app"
  zone_name           = azurerm_private_dns_zone.private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg-consumer.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_resource_group.rg-consumer.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-consumer.id
}
