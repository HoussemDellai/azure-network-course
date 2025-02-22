resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.hub_vnet_cidr]
}

resource "azurerm_subnet" "snet-firewall" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 12, 0)] # ["172.16.0.0/24"]
}

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 12, 1)] # ["172.16.1.0/27"]
}

resource "azurerm_subnet" "snet-jumpbox" {
  name                 = "snet-jumpbox"
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 12, 2)] # ["172.16.2.0/27"]
}