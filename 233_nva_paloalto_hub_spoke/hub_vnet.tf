resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  address_space       = ["172.16.0.0/12"] # until 172.31.255.255
}

resource "azurerm_subnet" "snet-trusted" {
  name                            = "snet-trusted"
  resource_group_name             = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet-hub.name
  address_prefixes                = ["172.16.0.0/24"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "snet-untrusted" {
  name                            = "snet-untrusted"
  resource_group_name             = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet-hub.name
  address_prefixes                = ["172.16.1.0/24"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "snet-hub-vm" {
  name                 = "snet-hub-vm"
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  address_prefixes     = ["172.16.2.0/27"]
}

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  address_prefixes     = ["172.16.3.0/27"]
}