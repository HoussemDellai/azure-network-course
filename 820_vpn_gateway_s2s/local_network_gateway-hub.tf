resource "azurerm_local_network_gateway" "lng-hub" {
  name                = "lng-hub"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  gateway_address     = azurerm_public_ip.pip-vpngateway-onprem.ip_address
  address_space       = ["${azurerm_virtual_network_gateway.vpngateway-onprem.bgp_settings[0].peering_addresses[0].default_addresses[0]}/32"]

  bgp_settings {
    asn                 = azurerm_virtual_network_gateway.vpngateway-onprem.bgp_settings[0].asn
    bgp_peering_address = azurerm_virtual_network_gateway.vpngateway-onprem.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }
}
