resource "azurerm_resource_group" "rg" {
  name     = "rg-opnsense-zenarmor-${var.prefix}"
  location = "belgiumcentral" # "swedencentral"
}
