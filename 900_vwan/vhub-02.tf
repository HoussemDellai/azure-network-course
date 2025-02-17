resource "azurerm_virtual_hub" "vhub-02" {
  name                                   = "vhub-02"
  resource_group_name                    = azurerm_resource_group.rg.name
  location                               = azurerm_resource_group.rg.location
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = "10.2.0.0/24"
  virtual_router_auto_scale_min_capacity = 2
  sku                                    = "Standard"

  # route {
  #   address_prefixes    = [""]
  #   next_hop_ip_address = ""
  # }
}
