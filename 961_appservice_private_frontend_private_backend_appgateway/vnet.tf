resource "azurerm_virtual_network" "vnet-app" {
  name                = "vnet-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-jumpbox" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "snet-integration" {
  name                 = "snet-integration"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.3.0/24"]

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
  resource_group_name               = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet-app.name
  address_prefixes                  = ["10.0.4.0/24"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "snet-appgateway" {
  name                 = "snet-appgateway"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.5.0/24"]
}
