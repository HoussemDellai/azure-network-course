resource "azurerm_route_table" "route_table_to_nva_spoke2" {
  name                          = "route-table-to-nva-spoke2"
  location                      = azurerm_resource_group.rg_spoke2.location
  resource_group_name           = azurerm_resource_group.rg_spoke2.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route_to_nva_spoke2" {
  name                   = "route-to-nva-spoke2"
  resource_group_name    = azurerm_resource_group.rg_spoke2.name
  route_table_name       = azurerm_route_table.route_table_to_nva_spoke2.name
  address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-spoke1.address_space[0] # "10.1.0.0/16" # 
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azapi_resource.hub_routing_appliance.output.properties.ipConfigurations.0.properties.privateIPAddress
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_spoke2" {
  subnet_id      = azurerm_subnet.snet_spoke2_workload.id
  route_table_id = azurerm_route_table.route_table_to_nva_spoke2.id
}
