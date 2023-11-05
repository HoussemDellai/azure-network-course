resource "azurerm_virtual_network_peering" "peering-vnet-1-to-vnet-2" {
  name                         = "peering-vnet-1-to-vnet-2"
  virtual_network_name         = azurerm_virtual_network.vnet-1.name
  resource_group_name          = azurerm_resource_group.rg-1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peering-vnet-2-to-vnet-1" {
  name                         = "peering-vnet-2-to-vnet-1"
  virtual_network_name         = azurerm_virtual_network.vnet-2.name
  resource_group_name          = azurerm_resource_group.rg-2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}