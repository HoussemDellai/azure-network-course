resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset-hub" {
  name                                       = "dns-forwarding-ruleset-hub"
  resource_group_name                        = azurerm_resource_group.rg-hub.name
  location                                   = azurerm_resource_group.rg-hub.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint-hub.id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "corp-azure-hub" {
  name                      = "corp-azure"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-hub.id
  domain_name               = "${azurerm_private_dns_zone.private-dns-zone-hub.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint-hub.ip_configurations.0.private_ip_address
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_forwarding_rule" "corp-internal-hub" {
  name                      = "corp-internal"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-hub.id
  domain_name               = "${azurerm_private_dns_zone.private-dns-zone-onprem.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint-onprem.ip_configurations.0.private_ip_address
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "dns-link-spoke" {
  name                      = "dns-link-spoke"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-hub.id
  virtual_network_id        = azurerm_virtual_network.vnet-spoke1.id
}

resource "azurerm_private_dns_resolver_virtual_network_link" "dns-link-spoke2" {
  name                      = "dns-link-spoke2"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-hub.id
  virtual_network_id        = azurerm_virtual_network.vnet-spoke2.id
}