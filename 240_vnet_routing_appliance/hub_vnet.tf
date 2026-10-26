resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  address_space       = ["172.16.0.0/12"] # until 172.31.255.255
}

resource "azurerm_subnet" "snet_routing_appliance" {
  name                 = "VirtualNetworkApplianceSubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "snet_bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  resource_group_name  = azurerm_virtual_network.vnet_hub.resource_group_name
  address_prefixes     = ["172.16.1.0/27"]
}