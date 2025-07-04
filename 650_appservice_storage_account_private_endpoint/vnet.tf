resource "azurerm_virtual_network" "vnet-app" {
  name                = "vnet-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-webapp" {
  name                 = "snet-webapp"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "snet-pe" {
  name                              = "snet-pe"
  resource_group_name               = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name              = azurerm_virtual_network.vnet-app.name
  address_prefixes                  = ["10.0.2.0/24"]
  private_endpoint_network_policies = "Enabled"
}
