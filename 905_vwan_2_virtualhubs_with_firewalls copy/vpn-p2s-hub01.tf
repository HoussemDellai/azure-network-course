resource "azurerm_vpn_server_configuration" "vpn-configuration-hub01" {
  name                     = "vpn-configuration-hub01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_virtual_hub.vhub01.location
  vpn_authentication_types = ["AAD"]     # Possible values are AAD (Azure Active Directory), Certificate and Radius.
  vpn_protocols            = ["OpenVPN"] # Possible values are IkeV2 and OpenVPN.

  azure_active_directory_authentication {
    audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    issuer   = "https://sts.windows.net/93139d1e-a3c1-4d78-9ed5-878be090eba4/"
    tenant   = "https://login.microsoftonline.com/93139d1e-a3c1-4d78-9ed5-878be090eba4"
  }
}

resource "azurerm_point_to_site_vpn_gateway" "vpn-p2s-gateway-hub01" {
  name                        = "vpn-p2s-gateway-hub01"
  location                    = azurerm_virtual_hub.vhub01.location
  resource_group_name         = azurerm_resource_group.rg.name
  virtual_hub_id              = azurerm_virtual_hub.vhub01.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpn-configuration-hub01.id
  scale_unit                  = 1
  # routing_preference_internet_enabled = 

  connection_configuration {
    name                      = "hub01_P2SConnectionConfig"
    internet_security_enabled = false

    vpn_client_address_pool {
      address_prefixes = ["172.16.1.0/24"]
    }
  }
}