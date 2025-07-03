resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-win11-swc-50"
  location = "swedencentral" # "francecentral" # "swedencentral"
}