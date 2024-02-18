resource "azurerm_private_dns_resolver" "private_dns_resolver-onprem" {
  name                = "dns-private-resolver-onprem"
  resource_group_name = azurerm_resource_group.rg-onprem.name
  location            = azurerm_resource_group.rg-onprem.location
  virtual_network_id  = azurerm_virtual_network.vnet-onprem.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint-onprem" {
  name                    = "inbound-endpoint-onprem"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver-onprem.id
  location                = azurerm_private_dns_resolver.private_dns_resolver-onprem.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet-onprem-dns-inbound.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound_endpoint-onprem" {
  name                    = "outbound-endpoint-onprem"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver-onprem.id
  location                = azurerm_private_dns_resolver.private_dns_resolver-onprem.location
  subnet_id               = azurerm_subnet.subnet-onprem-dns-outbound.id
}