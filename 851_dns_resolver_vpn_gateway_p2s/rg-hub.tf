resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-${var.prefix}"
  location = "westeurope"
}