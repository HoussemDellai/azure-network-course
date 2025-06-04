resource "azurerm_virtual_network" "vnet-spoke1" {
  name                = "vnet-spoke1"
  resource_group_name = azurerm_resource_group.rg-spoke1.name
  location            = azurerm_resource_group.rg-spoke1.location
  address_space       = ["10.1.0.0/16"]
  dns_servers         = [module.vm-hub-nva.vm_private_ip]
}

resource "azurerm_subnet" "subnet-spoke1-workload" {
  name                 = "subnet-spoke1-workload"
  resource_group_name  = azurerm_virtual_network.vnet-spoke1.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke1.name
  address_prefixes     = ["10.1.0.0/24"]
}