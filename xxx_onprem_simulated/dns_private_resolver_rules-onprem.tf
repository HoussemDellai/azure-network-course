resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset-onprem" {
  name                                       = "dns-forwarding-ruleset-onprem"
  resource_group_name                        = azurerm_resource_group.rg-onprem.name
  location                                   = azurerm_resource_group.rg-onprem.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint-onprem.id]
}

# resource "azurerm_private_dns_resolver_forwarding_rule" "corp-internal" {
#   name                      = "corp-internal"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-onprem.id
#   domain_name               = "${azurerm_private_dns_zone.private-dns-zone-onprem.name}."
#   enabled                   = true

#   target_dns_servers {
#     ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint-onprem.ip_configurations.0.private_ip_address
#     port       = 53
#   }
# }

resource "azurerm_private_dns_resolver_forwarding_rule" "corp-azure-onprem" {
  name                      = "corp-azure"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-onprem.id
  domain_name               = "${azurerm_private_dns_zone.private-dns-zone-hub.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint-hub.ip_configurations.0.private_ip_address
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "dns-link-onprem" {
  name                      = "dns-link-onprem"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset-onprem.id
  virtual_network_id        = azurerm_virtual_network.vnet-onprem.id
}