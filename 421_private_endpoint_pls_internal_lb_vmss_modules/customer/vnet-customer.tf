resource "azurerm_virtual_network" "vnet-customer" {
  name                = "vnet-customer"
  resource_group_name = azurerm_resource_group.rg-consumer.name
  location            = azurerm_resource_group.rg-consumer.location
  address_space       = ["10.1.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-customer" {
  name                                          = "subnet-customer"
  virtual_network_name                          = azurerm_virtual_network.vnet-customer.name
  resource_group_name                           = azurerm_virtual_network.vnet-customer.resource_group_name
  address_prefixes                              = ["10.1.0.0/24"]
  private_link_service_network_policies_enabled = false
}