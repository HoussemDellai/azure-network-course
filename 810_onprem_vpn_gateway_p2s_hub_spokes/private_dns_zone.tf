resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "internal.corp"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "a-record" {
  name                = "vm"
  zone_name           = azurerm_private_dns_zone.private-dns-zone.name
  resource_group_name = azurerm_private_dns_zone.private-dns-zone.resource_group_name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.vm.private_ip_address] # just example IP address
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet" {
  name                  = "link-dns-vnet"
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}