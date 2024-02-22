resource "azurerm_public_ip" "pip-vpngateway-hub" {
  name                = "pip-vpngateway-hub"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpngateway-hub" {
  name                = "vpngateway-hub"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"
  generation          = "Generation1"

  bgp_settings {
    asn = "65000"
  }

  ip_configuration {
    name                          = "vpngw-ip-config"
    public_ip_address_id          = azurerm_public_ip.pip-vpngateway-hub.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-hub-gateway.id
  }
}
