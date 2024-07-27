resource "azurerm_resource_group" "rg" {
  name     = "rg-frontdoor-appservice-${var.prefix}"
  location = var.location1
}