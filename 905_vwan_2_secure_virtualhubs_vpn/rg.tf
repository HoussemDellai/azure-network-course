resource "azurerm_resource_group" "rg" {
  name     = "rg-vwan-2-secure-vhubs-vpn-p2s-bastion-${var.prefix}"
  location = var.region1
}