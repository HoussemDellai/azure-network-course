resource "azurerm_private_endpoint" "pe-key-vault" {
  name                          = "pe-key-vault"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  subnet_id                     = azurerm_subnet.snet-pe.id
  custom_network_interface_name = "nic-pe-key-vault"

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  # private_dns_zone_group {
  #   name                 = "group"
  #   private_dns_zone_ids = [azurerm_private_dns_zone.dns-zone-key-vault.id]
  # }
}
