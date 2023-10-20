resource azurerm_resource_group "rg" {
  name     = "rg-vnet"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-application"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "subnet_1" {
  name                                      = "subnet-1"
  resource_group_name                       = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet.name
  address_prefixes                          = ["10.0.0.0/16"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "subnet_2" {
  name                                      = "subnet-2"
  resource_group_name                       = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet.name
  address_prefixes                          = ["10.1.0.0/16"]
  private_endpoint_network_policies_enabled = false
}