resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = "dns-private-resolver"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_network_id  = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint" {
  name                    = "inbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = azurerm_private_dns_resolver.private_dns_resolver.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.snet-inbound-dns.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound_endpoint" {
  name                    = "outbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = azurerm_private_dns_resolver.private_dns_resolver.location
  subnet_id               = azurerm_subnet.snet-outbound-dns.id
}