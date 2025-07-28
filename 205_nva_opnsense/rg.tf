resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-nva-opnsense-${var.prefix}-21-7"
  location = "swedencentral" # "swedencentral" #  # "swedencentral"
}