resource "azurerm_route_table" "route_table_to_nva_spoke1" {
  name                          = "route-table-to-nva-spoke1"
  location                      = azurerm_resource_group.rg_spoke1.location
  resource_group_name           = azurerm_resource_group.rg_spoke1.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-nva-spoke1" {
  name                   = "route-to-nva-spoke1"
  resource_group_name    = azurerm_resource_group.rg_spoke1.name
  route_table_name       = azurerm_route_table.route_table_to_nva_spoke1.name
  address_prefix         = "10.0.0.0/8" 
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azapi_resource.hub_routing_appliance.output.properties.ipConfigurations.0.properties.privateIPAddress
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_spoke1" {
  subnet_id      = azurerm_subnet.snet_spoke1_workload.id
  route_table_id = azurerm_route_table.route_table_to_nva_spoke1.id
}
