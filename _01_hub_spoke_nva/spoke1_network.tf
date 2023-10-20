resource azurerm_resource_group "rg-spoke1" {
  name     = "rg-spoke1"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet-spoke1" {
  name                = "vnet-spoke1"
  resource_group_name = azurerm_resource_group.rg-spoke1.name
  location            = azurerm_resource_group.rg-spoke1.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet-spoke1-workload" {
  name                                      = "subnet-spoke1-workload"
  resource_group_name                       = azurerm_virtual_network.vnet-spoke1.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet-spoke1.name
  address_prefixes                          = ["10.1.0.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_virtual_network_peering" "vnet-peering-hub-to-spoke1" {
  name                         = "vnet-peering-hub-to-spoke1"
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  resource_group_name          = azurerm_virtual_network.vnet-hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet-peering-spoke1-to-hub" {
  name                         = "vnet-peering-spoke1-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke1.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}