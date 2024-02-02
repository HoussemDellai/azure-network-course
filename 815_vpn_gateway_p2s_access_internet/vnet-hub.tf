resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub-weu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-vm" {
  name                 = "subnet-vm"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet-gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.2.0/24"]
}