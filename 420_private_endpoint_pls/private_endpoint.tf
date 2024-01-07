resource "azurerm_private_endpoint" "pe-consumer" {
  name                          = "pe-consumer"
  location                      = azurerm_resource_group.rg-consumer.location
  resource_group_name           = azurerm_resource_group.rg-consumer.name
  subnet_id                     = azurerm_subnet.subnet-consumer.id
  custom_network_interface_name = "nic-pe-consumer"

  private_service_connection {
    name                           = "pls-connection"
    private_connection_resource_id = azurerm_private_link_service.pls-provider.id
    is_manual_connection           = false
  }

  #   DNS configuration is not available for private endpoints connected to a private link service.
  #   private_dns_zone_group {
  #     name                 = "private-dns-zone-group"
  #     private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone.id]
  #   }
}
