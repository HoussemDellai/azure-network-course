resource "azurerm_public_ip" "pip-vnet-gateway" {
  name                = "pip-vnet-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # for Basic VPN Gateway
  allocation_method = "Dynamic"
  sku               = "Basic"

  # allocation_method   = "Static"
  # sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn-gateway" {
  name                = "vpn-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"        # ExpressRoute
  vpn_type = "RouteBased" # PolicyBased

  active_active = false
  enable_bgp    = false
  # sku           = "VpnGw2"      # Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ
  # generation    = "Generation2" # Generation2 is only value for a sku larger than VpnGw2 or VpnGw2AZ

  sku        = "Basic"
  generation = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vnet-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-gateway.id
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]

    root_certificate {
      name             = "P2SRootCert800"
      public_cert_data = replace(replace(file("./certs/P2SRootCert800.cer"), "-----BEGIN CERTIFICATE-----", ""), "-----END CERTIFICATE-----", "")
    }
  }
}
