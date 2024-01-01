resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-public-${var.prefix}"
  location = "westeurope"
}