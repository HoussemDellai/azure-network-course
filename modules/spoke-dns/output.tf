output "private_dns_zone_id_appservice" {
  value = azurerm_private_dns_zone.dns_zone_appservice.id
}

output "dns_forwarding_ruleset_id" {
  value = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset.id
}