resource "azurerm_virtual_hub" "vhub01" {
  name                                   = "vhub01"
  resource_group_name                    = azurerm_resource_group.rg.name
  location                               = var.region1
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = "10.10.0.0/24"
  virtual_router_auto_scale_min_capacity = 2
  sku                                    = "Standard"
}