resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.spoke_vnet_cidr]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-jumpbox" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 0)]
}

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 1)]
}

resource "azurerm_subnet" "snet-integration" {
  name                 = "snet-integration"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 2)]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "snet-pe" {
  name                              = "snet-gateway"
  resource_group_name               = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet-spoke.name
  address_prefixes                  = [cidrsubnet(var.spoke_vnet_cidr, 8, 3)]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "snet-appgateway" {
  name                 = "snet-appgateway"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 4)]
}
