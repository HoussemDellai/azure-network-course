resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke-dns"
  location = var.location
}