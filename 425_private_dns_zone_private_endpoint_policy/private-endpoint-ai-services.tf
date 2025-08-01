resource "azurerm_private_endpoint" "private-endpoint-ai-services" {
  name                          = "pe-ai-services"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  subnet_id                     = azurerm_subnet.snet-pe.id
  custom_network_interface_name = "nic-pe-ai-services"

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_ai_services.ai-services.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  # private_dns_zone_group {
  #   name                 = "private-dns-zone-group"
  #   private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone.id]
  # }
}
