resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke"
  location = var.location
}