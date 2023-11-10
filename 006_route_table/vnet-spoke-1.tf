resource "azurerm_virtual_network" "vnet-spoke-1" {
  name                = "vnet-spoke-1"
  resource_group_name = azurerm_resource_group.rg-spoke-1.name
  location            = azurerm_resource_group.rg-spoke-1.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet-vm-spoke-1" {
  name                 = "subnet-vm-spoke-1"
  virtual_network_name = azurerm_virtual_network.vnet-spoke-1.name
  resource_group_name  = azurerm_virtual_network.vnet-spoke-1.resource_group_name
  address_prefixes     = ["10.1.0.0/24"]
}
