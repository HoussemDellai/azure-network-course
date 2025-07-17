resource "azurerm_resource_group" "rg" {
  name     = "rg-virtualwan-virtualhub-${var.prefix}"
  location = var.region1
}