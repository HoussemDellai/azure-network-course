resource "azurerm_private_endpoint" "pe-aca-environment" {
  name                          = "pe-aca-environment"
  location                      = azurerm_resource_group.rg-spoke2.location
  resource_group_name           = azurerm_resource_group.rg-spoke2.name
  subnet_id                     = azurerm_subnet.snet-spoke2-pe.id
  custom_network_interface_name = "nic-pe-aca-environment"

  private_service_connection {
    name                           = "connection-pe"
    private_connection_resource_id = azurerm_container_app_environment.env.id
    is_manual_connection           = false
    subresource_names              = ["managedEnvironments"]
  }

  private_dns_zone_group {
    name                 = "group-aca-environment"
    private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone-aca-environment.id]
  }
}

output "aca_pe_ip" {
  value = azurerm_private_endpoint.pe-aca-environment.private_service_connection.0.private_ip_address
}