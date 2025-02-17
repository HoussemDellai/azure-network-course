resource "azurerm_resource_group" "rg" {
  name     = "rg-virtualwan-${var.prefix}"
  location = "swedencentral"
}