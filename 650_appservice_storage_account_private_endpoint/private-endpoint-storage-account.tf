resource "azurerm_private_endpoint" "pe-storage-account" {
  name                          = "pe-storage-account"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  subnet_id                     = azurerm_subnet.snet-pe.id
  custom_network_interface_name = "nic-pe-storage-account"

  private_dns_zone_group {
    name                 = "group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-zone-storage-account.id]
  }

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_storage_account.storage-account.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}
