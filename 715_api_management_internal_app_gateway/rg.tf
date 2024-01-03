resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-internal-${var.prefix}"
  location = "westeurope"
}