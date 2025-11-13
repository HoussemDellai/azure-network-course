resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  location            = azurerm_resource_group.rg-paloalto.location
  resource_group_name = azurerm_resource_group.rg-paloalto.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-nva-paloalto" {
  name                                          = "snet-nva-paloalto"
  resource_group_name                           = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet-hub.name
  address_prefixes                              = ["10.0.0.0/24"]
  default_outbound_access_enabled               = false
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
}
