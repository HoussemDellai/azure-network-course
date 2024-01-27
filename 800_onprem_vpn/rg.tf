resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-gateway-${var.prefix}"
  location = "westeurope"
}