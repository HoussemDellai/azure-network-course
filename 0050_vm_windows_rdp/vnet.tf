resource "azurerm_virtual_network" "vnet-spoke-vm" {
  name                = "vnet-spoke-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-vm" {
  name                 = "snet-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke-vm.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-vm.name
  address_prefixes     = ["10.10.0.0/24"]
}