resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-storage-account-pe-${var.prefix}"
  location = "swedencentral"
}