resource "azurerm_resource_group" "rg" {
  name     = "rg-appgateway-vmss-tls-${var.prefix}"
  location = "westeurope"
}