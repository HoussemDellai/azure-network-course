resource "azurerm_virtual_network" "vnet-1" {
  name                = "vnet-1"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_virtual_network.vnet-1.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.1.0.0/24"]
}
