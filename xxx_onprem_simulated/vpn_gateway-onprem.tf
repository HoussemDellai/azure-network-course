resource "azurerm_public_ip" "pip-vpngateway-onprem" {
  name                = "pip-vpngateway-onprem"
  location            = azurerm_resource_group.rg-onprem.location
  resource_group_name = azurerm_resource_group.rg-onprem.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpngateway-onprem" {
  name                = "vpngateway-onprem"
  location            = azurerm_resource_group.rg-onprem.location
  resource_group_name = azurerm_resource_group.rg-onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  bgp_settings {
    asn = "64000"
  }

  ip_configuration {
    name                          = "vnetGatewayIpConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vpngateway-onprem.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-onprem-vpngateway.id
  }
}
