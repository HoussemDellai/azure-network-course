resource "azurerm_virtual_network_peering" "vnet-peering-hub-to-spoke" {
  name                         = "vnet-peering-hub-to-spoke"
  virtual_network_name         = module.hub.hub_vnet.name
  resource_group_name          = module.hub.hub_vnet.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet-peering-spoke-to-hub" {
  name                         = "vnet-peering-spoke-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke1.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke1.resource_group_name
  remote_virtual_network_id    = module.hub.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}