resource "azurerm_resource_group" "rg" {
  name     = "rg-vwan-2-vhubs-with-firewall-${var.prefix}"
  location = "swedencentral"
}