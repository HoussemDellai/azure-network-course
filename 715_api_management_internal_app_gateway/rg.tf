resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-internal-appgw-${var.prefix}"
  location = "westeurope"
}