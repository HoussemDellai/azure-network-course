resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-private-front-private-back-fw-${var.prefix}"
  location = var.location
}