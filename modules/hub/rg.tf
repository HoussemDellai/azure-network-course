resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-hub"
  location = var.location
}