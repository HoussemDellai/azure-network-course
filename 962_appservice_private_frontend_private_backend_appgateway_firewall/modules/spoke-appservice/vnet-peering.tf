resource "azurerm_virtual_network_peering" "vnet-peering-hub-to-spoke" {
  name                         = "vnet-peering-hub-to-spoke-${var.prefix}"
  virtual_network_name         = var.hub_vnet_name
  resource_group_name          = var.hub_vnet_rg_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet-peering-spoke-to-hub" {
  name                         = "vnet-peering-spoke-to-hub-${var.prefix}"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke.resource_group_name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}