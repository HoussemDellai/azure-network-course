resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-nva-opnsense-${var.prefix}"
  location = "swedencentral" # "swedencentral" #  # "swedencentral"
}
