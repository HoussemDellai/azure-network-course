resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-hub-vm" {
  name                 = "subnet-hub-vm"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet-hub-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.3.0/24"]
}