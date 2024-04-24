resource "azurerm_private_dns_resolver" "private_dns_resolver-hub" {
  name                = "dns-private-resolver-hub"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  virtual_network_id  = azurerm_virtual_network.vnet-hub.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint-hub" {
  name                    = "inbound-endpoint-hub"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver-hub.id
  location                = azurerm_private_dns_resolver.private_dns_resolver-hub.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet-hub-inbound-dns.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound_endpoint-hub" {
  name                    = "outbound-endpoint-hub"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver-hub.id
  location                = azurerm_private_dns_resolver.private_dns_resolver-hub.location
  subnet_id               = azurerm_subnet.subnet-hub-outbound-dns.id
}