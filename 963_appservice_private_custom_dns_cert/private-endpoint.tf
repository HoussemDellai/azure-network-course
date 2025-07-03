resource "azurerm_private_endpoint" "pe-webapp" {
  name                          = "pe-webapp"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  subnet_id                     = azurerm_subnet.snet-pe.id
  custom_network_interface_name = "pe-webapp-nic"

  private_dns_zone_group {
    name = "group"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dns-appservice.id,
      # azurerm_private_dns_zone.dns-appservice-custom.id # issue here, comment this line to fix
    ]
  }

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}