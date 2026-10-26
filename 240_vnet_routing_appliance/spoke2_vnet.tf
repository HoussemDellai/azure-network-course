resource "azurerm_virtual_network" "vnet_spoke2" {
  name                = "vnet-spoke2"
  resource_group_name = azurerm_resource_group.rg_spoke2.name
  location            = azurerm_resource_group.rg_spoke2.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "snet_spoke2_workload" {
  name                 = "snet_spoke2_workload"
  resource_group_name  = azurerm_virtual_network.vnet_spoke2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke2.name
  address_prefixes     = ["10.2.0.0/24"]
}