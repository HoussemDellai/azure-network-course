resource "azurerm_private_endpoint" "private-endpoint-mssql" {
  name                = "private-endpoint-mssql"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  subnet_id           = azurerm_subnet.snet-spoke2-pe.id

  private_service_connection {
    name                           = "private-service-connection"
    private_connection_resource_id = azurerm_mssql_server.mssql-server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone-mssql.id]
  }
}