module "spoke1" {
  source                = "./modules/spoke"
  spoke_name            = "spoke1-${var.prefix}"
  spoke_rg_location     = azurerm_resource_group.rg.location
  spoke_vnet_cidr       = "10.1.0.0/16"
  allow_gateway_transit = true
  hub_vnet = {
    name = azurerm_virtual_network.vnet-hub.name
    rg   = azurerm_virtual_network.vnet-hub.resource_group_name
    id   = azurerm_virtual_network.vnet-hub.id
  }
}

module "spoke2" {
  source                = "./modules/spoke"
  spoke_name            = "spoke2-${var.prefix}"
  spoke_rg_location     = azurerm_resource_group.rg.location
  spoke_vnet_cidr       = "10.2.0.0/16"
  allow_gateway_transit = false
  hub_vnet = {
    name = azurerm_virtual_network.vnet-hub.name
    rg   = azurerm_virtual_network.vnet-hub.resource_group_name
    id   = azurerm_virtual_network.vnet-hub.id
  }
}
