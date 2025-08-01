resource "azurerm_virtual_wan" "vwan" {
  name                           = "vwan"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = var.region1
  type                           = "Standard"
  allow_branch_to_branch_traffic = true
  disable_vpn_encryption         = false
}
