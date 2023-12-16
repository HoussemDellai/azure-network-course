resource "azurerm_virtual_network" "vnet-consumer" {
  name                = "vnet-consumer"
  resource_group_name = azurerm_resource_group.rg-consumer.name
  location            = azurerm_resource_group.rg-consumer.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-consumer" {
  name                                          = "subnet-consumer"
  virtual_network_name                          = azurerm_virtual_network.vnet-consumer.name
  resource_group_name                           = azurerm_virtual_network.vnet-consumer.resource_group_name
  address_prefixes                              = ["10.0.0.0/24"]
  private_link_service_network_policies_enabled = false
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-consumer.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-consumer.name
  address_prefixes     = ["10.0.1.0/24"]
}
