resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-aks-${var.prefix}"
  location = "swedencentral"
}