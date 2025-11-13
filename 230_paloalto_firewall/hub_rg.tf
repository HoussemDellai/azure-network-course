resource "azurerm_resource_group" "rg-paloalto" {
  name     = "rg-hub-nva-paloalto-vmseries-${var.prefix}"
  location = "swedencentral"
}
