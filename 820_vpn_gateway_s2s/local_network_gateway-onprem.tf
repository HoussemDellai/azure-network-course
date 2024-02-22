resource "azurerm_local_network_gateway" "lng-onprem" {
  name                = "lng-onprem"
  resource_group_name = azurerm_resource_group.rg-onprem.name
  location            = azurerm_resource_group.rg-onprem.location
  gateway_address     = azurerm_public_ip.pip-vpngateway-hub.ip_address
  address_space       = ["${azurerm_virtual_network_gateway.vpngateway-hub.bgp_settings[0].peering_addresses[0].default_addresses[0]}/32"]

  bgp_settings {
    asn                 = azurerm_virtual_network_gateway.vpngateway-hub.bgp_settings[0].asn
    bgp_peering_address = azurerm_virtual_network_gateway.vpngateway-hub.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }
}