resource "azurerm_resource_group" "rg-onprem" {
  name     = "rg-onprem-${var.prefix}"
  location = "swedencentral"
}