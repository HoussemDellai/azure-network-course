resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-win11-swc-${var.prefix}"
  location = "swedencentral" # "francecentral" # "swedencentral"
}