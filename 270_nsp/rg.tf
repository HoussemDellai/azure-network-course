resource "azurerm_resource_group" "rg" {
  name     = "rg-nsp-foundry-${var.prefix}"
  location = "northcentralus" # "swedencentral"
}