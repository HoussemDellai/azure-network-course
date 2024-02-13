resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke"
  resource_group_name = azurerm_resource_group.rg-spoke.name
  location            = azurerm_resource_group.rg-spoke.location
  address_space       = ["10.1.0.0/16"]
  dns_servers         = null
}