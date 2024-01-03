resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-external-${var.prefix}"
  location = "westeurope"
}