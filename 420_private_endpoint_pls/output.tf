output "pe_ip" {
  value = azurerm_private_endpoint.pe-consumer.private_service_connection.0.private_ip_address
}

output "pe_dns" {
  value = azurerm_private_dns_a_record.a-record.fqdn
}