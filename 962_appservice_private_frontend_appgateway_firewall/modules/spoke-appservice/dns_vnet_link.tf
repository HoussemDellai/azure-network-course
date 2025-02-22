resource "azurerm_private_dns_resolver_virtual_network_link" "dns_vnet_link" {
  name                      = "dns-vnet-link-${var.prefix}"
  dns_forwarding_ruleset_id = var.dns_forwarding_ruleset_id
  virtual_network_id        = azurerm_virtual_network.vnet-spoke.id
}
