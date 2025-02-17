resource "azurerm_vpn_server_configuration" "vpn-configuration" {
  name                     = "vpn-configuration"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  vpn_authentication_types = ["AAD"]

  azure_active_directory_authentication {
    audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    issuer   = "https://sts.windows.net/93139d1e-a3c1-4d78-9ed5-878be090eba4/"
    tenant   = "https://login.microsoftonline.com/93139d1e-a3c1-4d78-9ed5-878be090eba4"
  }
}
