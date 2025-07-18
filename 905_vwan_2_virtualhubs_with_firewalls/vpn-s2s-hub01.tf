resource "azurerm_vpn_gateway" "vpn-gateway-vhub01" {
  name                = "vpn-gateway-vhub01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  virtual_hub_id      = azurerm_virtual_hub.vhub01.id
  routing_preference  = "Microsoft Network" # "Microsoft Network" or "Internet"
  scale_unit          = 1
}

resource "azurerm_vpn_site" "vpn-site" {
  name                = "vpn-site"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_cidrs       = ["172.16.0.0/24"]

  link {
    name       = "link1"
    ip_address = "10.1.0.0"
  }
}

resource "azurerm_vpn_gateway_connection" "vpn-gateway-connection-vhub01" {
  name                      = "vpn-gateway-connection-vhub01"
  vpn_gateway_id            = azurerm_vpn_gateway.vpn-gateway-vhub01.id
  remote_vpn_site_id        = azurerm_vpn_site.vpn-site.id
  internet_security_enabled = false

  vpn_link {
    name             = "link1"
    vpn_site_link_id = azurerm_vpn_site.vpn-site.link.0.id
    bandwidth_mbps   = 100
    shared_key       = random_string.vpn-psk.result
  }
}

resource "random_string" "vpn-psk" {
  length = 32
}