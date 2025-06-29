resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-win11-swc" # "rg-vm-win-swe-01"
  location = "swedencentral" # "francecentral" # "swedencentral"
}