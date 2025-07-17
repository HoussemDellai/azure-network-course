resource "azurerm_resource_group" "rg" {
  name     = "rg-virtualwan-2-virtualhubs-${var.prefix}"
  location = var.region1
}