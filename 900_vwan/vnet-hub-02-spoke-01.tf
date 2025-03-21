resource "azurerm_virtual_network" "vnet-hub-02-spoke-01" {
  name                = "vnet-hub-02-spoke-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.21.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-vnet-hub-02-spoke-01-vm" {
  name                 = "snet-vnet-hub-02-spoke-01-vm"
  resource_group_name  = azurerm_virtual_network.vnet-hub-02-spoke-01.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub-02-spoke-01.name
  address_prefixes     = ["10.21.0.0/24"]
}