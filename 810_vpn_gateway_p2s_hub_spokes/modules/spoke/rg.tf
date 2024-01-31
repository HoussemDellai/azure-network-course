resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.spoke_name}"
  location = var.spoke_rg_location
}