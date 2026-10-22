resource "azurerm_resource_group" "rg_spoke2" {
  name     = "rg-spoke2-${var.prefix}"
  location = "swedencentral"
}