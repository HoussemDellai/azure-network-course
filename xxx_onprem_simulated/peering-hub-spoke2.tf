resource "azurerm_virtual_network_peering" "peering-hub-to-spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.rg-hub.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}

resource "azurerm_virtual_network_peering" "peering-spoke2-to-hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.rg-spoke2.name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}