resource "azurerm_resource_group" "rg" {
  name     = "rg-lb-internal-vmss"
  location = "westeurope"
}