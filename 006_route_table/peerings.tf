resource "azurerm_virtual_network_peering" "peering-hub-to-spoke-1" {
  name                         = "peering-hub-to-spoke-1"
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  resource_group_name          = azurerm_virtual_network.vnet-hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke-1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peering-spoke-1-to-hub" {
  name                         = "peering-spoke-1-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke-1.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke-1.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peering-hub-to-spoke-2" {
  name                         = "peering-hub-to-spoke-2"
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  resource_group_name          = azurerm_virtual_network.vnet-hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke-2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "peering-spoke-2-to-hub" {
  name                         = "peering-spoke-2-to-hub"
  virtual_network_name         = azurerm_virtual_network.vnet-spoke-2.name
  resource_group_name          = azurerm_virtual_network.vnet-spoke-2.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}