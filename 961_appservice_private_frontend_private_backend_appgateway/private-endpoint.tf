resource "azurerm_private_endpoint" "pe-frontend" {
  name                = "pe-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet-pe.id

  private_dns_zone_group {
    name                 = "group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-appservice.id]
  }

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_linux_web_app.frontend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "pe-backend" {
  name                = "pe-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet-pe.id

  private_dns_zone_group {
    name                 = "group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-appservice.id]
  }

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_linux_web_app.backend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
