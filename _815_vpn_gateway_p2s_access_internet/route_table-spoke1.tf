resource "azurerm_route_table" "route-table" {
  name                          = "route-table"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-firewall" {
  name                   = "route-to-firewal"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route-table.name
  address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-spoke.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "association-route-table-snet-vm" {
  subnet_id      = azurerm_subnet.snet-vm.id
  route_table_id = azurerm_route_table.route-table.id
}
