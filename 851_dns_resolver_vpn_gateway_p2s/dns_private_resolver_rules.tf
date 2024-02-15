resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset" {
  name                                       = "dns-forwarding-ruleset"
  resource_group_name                        = azurerm_resource_group.rg.name
  location                                   = azurerm_resource_group.rg.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint.id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "rule1" {
  name                      = "hub-internal"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
  domain_name               = "${azurerm_private_dns_zone.private-dns-zone-hub.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations.0.private_ip_address
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_forwarding_rule" "rule2" {
  name                      = "spoke-internal"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
  domain_name               = "${azurerm_private_dns_zone.private-dns-zone-spoke.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations.0.private_ip_address
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "vnet_link_spoke" {
  name                      = "vnet-link-spoke"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
  virtual_network_id        = azurerm_virtual_network.vnet-spoke.id
}

#-------------------------------------------------------------------------------
# If you use the ruleset link option and there is a forwarding rule with the inbound endpoint as destination, 
# do not link the forwarding ruleset to the Hub VNet. 
# Linking this type of ruleset to the same VNet where the inbound endpoint is provisioned can result in a DNS resolution loop.
# src: https://learn.microsoft.com/en-us/azure/dns/private-resolver-endpoints-rulesets#forwarding-ruleset-links
#-------------------------------------------------------------------------------
# resource "azurerm_private_dns_resolver_virtual_network_link" "vnet_link_hub" {
#   name                      = "vnet-link-hub"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
#   virtual_network_id        = azurerm_virtual_network.vnet-hub.id
# }
