resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-private-front-private-back-${var.prefix}"
  location = "swedencentral"
}