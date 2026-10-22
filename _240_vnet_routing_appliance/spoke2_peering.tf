resource "azurerm_virtual_network_peering" "vnet_peering_hub_to_spoke2" {
  name                         = "vnet-peering-hub-to-spoke2"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_spoke2_to_hub" {
  name                         = "vnet-peering-spoke2-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet_spoke2.name
  resource_group_name          = azurerm_virtual_network.vnet_spoke2.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}