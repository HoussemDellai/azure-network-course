resource "azurerm_virtual_network_peering" "peering-hub-to-spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = azurerm_resource_group.rg-hub.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}

resource "azurerm_virtual_network_peering" "peering-spoke1-to-hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.rg-spoke1.name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}
