resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-${var.prefix}"
  location = var.location
}