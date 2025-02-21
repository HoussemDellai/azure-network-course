resource "azurerm_private_dns_resolver_virtual_network_link" "dns_vnet_link" {
  for_each = var.vnet_ids

  name                      = "dns-vnet-link-${split("/", each.value)[4]}-${split("/", each.value)[8]}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
  virtual_network_id        = each.value
}
