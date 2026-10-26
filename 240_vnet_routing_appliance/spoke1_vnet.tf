resource "azurerm_virtual_network" "vnet_spoke1" {
  name                = "vnet-spoke1"
  resource_group_name = azurerm_resource_group.rg_spoke1.name
  location            = azurerm_resource_group.rg_spoke1.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "snet_spoke1_workload" {
  name                 = "snet-spoke1-workload"
  resource_group_name  = azurerm_virtual_network.vnet_spoke1.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke1.name
  address_prefixes     = ["10.1.0.0/24"]
}