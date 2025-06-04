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
  address_prefixes     = [var.hub_vnet_cidr]
}