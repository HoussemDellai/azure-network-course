resource "azurerm_resource_group" "rg_spoke1" {
  name     = "rg-spoke1-${var.prefix}"
  location = "swedencentral"
}