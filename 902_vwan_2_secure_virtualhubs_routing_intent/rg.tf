resource "azurerm_resource_group" "rg" {
  name     = "rg-vwan-2-secure-vhubs-routing-intent-${var.prefix}"
  location = var.region1
}