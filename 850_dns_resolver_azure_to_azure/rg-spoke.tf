resource "azurerm_resource_group" "rg-spoke" {
  name     = "rg-spoke-${var.prefix}"
  location = "swedencentral"
}