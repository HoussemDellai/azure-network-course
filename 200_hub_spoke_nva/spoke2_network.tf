resource "azurerm_resource_group" "rg-spoke2" {
  name     = "rg-spoke2"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet-spoke2" {
  name                = "vnet-spoke2"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  location            = azurerm_resource_group.rg-spoke2.location
  address_space       = ["10.2.0.0/16"]
  dns_servers         = [module.vm-hub-nva.virtual_machine_private_ip]
}

resource "azurerm_subnet" "subnet-spoke2-workload" {
  name                                      = "subnet-spoke2-workload"
  resource_group_name                       = azurerm_virtual_network.vnet-spoke2.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet-spoke2.name
  address_prefixes                          = ["10.2.0.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_virtual_network_peering" "vnet-peering-hub-to-spoke2" {
  name                         = "vnet-peering-hub-to-spoke2"
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  resource_group_name          = azurerm_virtual_network.vnet-hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet-peering-spoke2-to-hub" {
  name                         = "vnet-peering-spoke2-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke2.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke2.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}