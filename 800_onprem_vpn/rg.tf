resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-gateway-basic-${var.prefix}"
  location = "westeurope"
}