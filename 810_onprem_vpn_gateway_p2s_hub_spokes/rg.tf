resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-vpngw-${var.prefix}"
  location = "westeurope"
}