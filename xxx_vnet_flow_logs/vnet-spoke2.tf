resource "azurerm_virtual_network" "vnet-spoke2" {
  name                = "vnet-spoke2"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  address_space       = ["10.2.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-spoke2-vm" {
  name                 = "subnet-spoke2-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke2.name
  address_prefixes     = ["10.2.0.0/24"]
}