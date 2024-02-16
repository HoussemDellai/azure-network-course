resource "azurerm_virtual_network_peering" "peering-hub-to-spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.rg-hub.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}

resource "azurerm_virtual_network_peering" "peering-spoke-to-hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = azurerm_resource_group.rg-spoke.name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}
