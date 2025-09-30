resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = "dce"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}