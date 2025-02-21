resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset" {
  name                                       = "dns-forwarding-ruleset"
  resource_group_name                        = azurerm_resource_group.rg.name
  location                                   = azurerm_resource_group.rg.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint.id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "rule_appservice" {
  name                      = "rule-appservice"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
  domain_name               = "${azurerm_private_dns_zone.dns_zone_appservice.name}."
  enabled                   = true

  target_dns_servers {
    ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations.0.private_ip_address
    port       = 53
  }
}

# resource "azurerm_private_dns_resolver_forwarding_rule" "rule2" {
#   name                      = "spoke-internal"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
#   domain_name               = "${azurerm_private_dns_zone.private-dns-zone-spoke.name}."
#   enabled                   = true

#   target_dns_servers {
#     ip_address = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations.0.private_ip_address
#     port       = 53
#   }
# }
