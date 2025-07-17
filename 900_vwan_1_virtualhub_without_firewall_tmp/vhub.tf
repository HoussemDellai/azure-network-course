# resource "azurerm_virtual_hub" "vhub" {
#   name                                   = "vhub"
#   resource_group_name                    = azurerm_resource_group.rg.name
#   location                               = azurerm_resource_group.rg.location
#   virtual_wan_id                         = azurerm_virtual_wan.vwan.id
#   address_prefix                         = "10.1.0.0/24"
#   sku                                    = "Standard"
#   virtual_router_auto_scale_min_capacity = 2
#   # hub_routing_preference                 = "ExpressRoute" # Possible values are ExpressRoute, ASPath and VpnGateway. Defaults to ExpressRoute}
# }

resource "azurerm_virtual_hub" "vhub02" {
  name                                   = "vhub02"
  resource_group_name                    = azurerm_resource_group.rg.name
  location                               = azurerm_resource_group.rg.location
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = "10.2.0.0/16"
  sku                                    = "Standard"
  virtual_router_auto_scale_min_capacity = 2
  # hub_routing_preference                 = "ExpressRoute" # Possible values are ExpressRoute, ASPath and VpnGateway. Defaults to ExpressRoute}
}
