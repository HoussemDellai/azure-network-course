resource "azurerm_virtual_network" "vnet-spoke-2" {
  name                = "vnet-spoke-2"
  resource_group_name = azurerm_resource_group.rg-spoke-2.name
  location            = azurerm_resource_group.rg-spoke-2.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "subnet-vm-spoke-2" {
  name                 = "subnet-vm-spoke-2"
  virtual_network_name = azurerm_virtual_network.vnet-spoke-2.name
  resource_group_name  = azurerm_virtual_network.vnet-spoke-2.resource_group_name
  address_prefixes     = ["10.2.0.0/24"]
}
