resource "azurerm_virtual_network_gateway_connection" "hub-to-onprem" {
  name                       = "hub-to-onprem"
  resource_group_name        = azurerm_resource_group.rg-hub.name
  location                   = azurerm_resource_group.rg-hub.location
  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngateway-hub.id
  local_network_gateway_id   = azurerm_local_network_gateway.lng-hub.id
  shared_key                 = "sample-shared-key"
}

resource "azurerm_virtual_network_gateway_connection" "onprem-to-hub" {
  name                       = "onprem-to-hub"
  resource_group_name        = azurerm_resource_group.rg-onprem.name
  location                   = azurerm_resource_group.rg-onprem.location
  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngateway-onprem.id
  local_network_gateway_id   = azurerm_local_network_gateway.lng-onprem.id
  shared_key                 = "sample-shared-key"
}
