resource "azurerm_virtual_network" "vnet-app" {
  name                = "vnet-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-apim" {
  name                 = "subnet-apim"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}

resource "azurerm_subnet" "subnet-jumpbox" {
  name                 = "subnet-jumpbox"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet-appgw" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_virtual_network.vnet-app.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.0.3.0/24"]
}