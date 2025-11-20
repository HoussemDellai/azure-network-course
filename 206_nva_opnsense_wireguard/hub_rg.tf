resource "azurerm_resource_group" "rg" {
  name     = "rg-opnsense-wg-lb-${var.prefix}"
  location = "swedencentral"
}
