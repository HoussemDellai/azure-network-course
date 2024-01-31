resource "azurerm_resource_group" "rg" {
  name     = "rg-vpn-gateway-p2s-${var.prefix}"
  location = "westeurope"
}