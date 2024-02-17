resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-spoke-vm" {
  name                 = "subnet-spoke-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.1.0.0/24"]
}