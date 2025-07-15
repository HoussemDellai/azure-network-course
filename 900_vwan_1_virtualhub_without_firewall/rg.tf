resource "azurerm_resource_group" "rg" {
  name     = "rg-virtualwan-1-vhub-no-firewall-${var.prefix}"
  location = "swedencentral"
}