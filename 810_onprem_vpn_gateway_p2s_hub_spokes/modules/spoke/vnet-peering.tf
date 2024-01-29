resource "azurerm_virtual_network_peering" "peering-hub-to-spoke" {
  name                         = "peering-hub-to-${var.spoke_name}"
  virtual_network_name         = var.hub_vnet.name
  resource_group_name          = var.hub_vnet.rg
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "peering-spoke-to-hub" {
  name                         = "peering-${var.spoke_name}-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke.resource_group_name
  remote_virtual_network_id    = var.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}