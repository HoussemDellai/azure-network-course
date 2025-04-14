resource "azurerm_resource_group" "rg" {
  name     = "rg-appgw-vmss-tls-${var.prefix}"
  location = "swedencentral"
}