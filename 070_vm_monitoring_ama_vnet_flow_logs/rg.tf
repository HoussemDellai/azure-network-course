resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-monitoring-${var.prefix}"
  location = "swedencentral"
}