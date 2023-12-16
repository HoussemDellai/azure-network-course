resource "azurerm_virtual_network" "vnet-provider" {
  name                = "vnet-provider"
  resource_group_name = azurerm_resource_group.rg-provider.name
  location            = azurerm_resource_group.rg-provider.location
  address_space       = ["10.1.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-provider" {
  name                 = "subnet-provider"
  virtual_network_name = azurerm_virtual_network.vnet-provider.name
  resource_group_name  = azurerm_virtual_network.vnet-provider.resource_group_name
  address_prefixes     = ["10.1.0.0/24"]

  # to choose a source IP address for your Private Link service
  private_link_service_network_policies_enabled = false
}
