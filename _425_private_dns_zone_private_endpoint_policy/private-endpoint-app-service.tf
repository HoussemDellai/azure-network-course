resource "azurerm_private_endpoint" "private-endpoint-app-service" {
  name                          = "private-endpoint-app-service"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  subnet_id                     = azurerm_subnet.snet-pe.id
  custom_network_interface_name = "nic-private-endpoint-app-service"

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_linux_web_app.web-app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  # private_dns_zone_group {
  #   name                 = "group"
  #   private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone-app-service.id]
  # }
}
