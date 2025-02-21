resource "azurerm_route_table" "route-table-to-nva-spoke" {
  name                          = "route-table-to-nva-spoke"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-nva-spoke" {
  name                   = "route-to-nva-spoke"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route-table-to-nva-spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_spoke1" {
  subnet_id      = azurerm_subnet.snet-integration.id
  route_table_id = azurerm_route_table.route-table-to-nva-spoke.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_snet_jumpbox" {
  subnet_id      = azurerm_subnet.snet-jumpbox.id
  route_table_id = azurerm_route_table.route-table-to-nva-spoke.id
}