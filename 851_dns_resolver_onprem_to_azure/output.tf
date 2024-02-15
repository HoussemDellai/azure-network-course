output "dns_private_resolver_inbound_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations.0.private_ip_address
}

output "private_dns_zone_hub_name" {
  value = azurerm_private_dns_zone.private-dns-zone-hub.name
}