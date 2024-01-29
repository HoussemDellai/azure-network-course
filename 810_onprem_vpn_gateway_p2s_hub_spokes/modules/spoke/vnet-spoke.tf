resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-${var.spoke_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.spoke_vnet_cidr]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-vm" {
  name                 = "subnet-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 0)]
}