resource "azurerm_resource_group" "rg_hub" {
  name     = "rg-hub-${var.prefix}"
  location = "swedencentral"
}