resource "azurerm_resource_group" "rg" {
  name     = "rg-nsp-${var.prefix}"
  location = "swedencentral"
}