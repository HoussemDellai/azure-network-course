resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.1.0/26", "100.64.0.0/10"]
}

resource "azurerm_subnet" "snet-routed-firewall" {
  name                 = "AzureFirewallSubnet" # "snet-routed-firewall"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "snet-not-routed-firewall-management" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["100.64.1.0/26"]
}

resource "azurerm_subnet" "snet-not-routed-aks" {
  name                 = "snet-not-routed-aks"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["100.64.0.0/26"]
}
