resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-custom-private-dns-${var.prefix}"
  location = "swedencentral"
}