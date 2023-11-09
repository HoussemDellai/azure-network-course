resource "azurerm_virtual_network" "vnet-2" {
  name                = "vnet-2"
  resource_group_name = azurerm_resource_group.rg-2.name
  location            = azurerm_resource_group.rg-2.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_virtual_network.vnet-2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-2.name
  address_prefixes     = ["10.2.0.0/24"]
}
