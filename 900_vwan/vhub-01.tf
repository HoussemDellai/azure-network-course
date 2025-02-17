resource "azurerm_virtual_hub" "vhub-01" {
  name                                   = "vhub-01"
  resource_group_name                    = azurerm_resource_group.rg.name
  location                               = azurerm_resource_group.rg.location
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = "10.1.0.0/24"
  virtual_router_auto_scale_min_capacity = 2
  sku                                    = "Standard"
  # hub_routing_preference = # Possible values are ExpressRoute, ASPath and VpnGateway. Defaults to ExpressRoute

  # route {
  #   address_prefixes    = [""]
  #   next_hop_ip_address = ""
  # }
}
