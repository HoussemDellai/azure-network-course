resource "azurerm_route_table" "route-table-spoke-1" {
  name                          = "route-table-spoke-1"
  location                      = azurerm_resource_group.rg-spoke-1.location
  resource_group_name           = azurerm_resource_group.rg-spoke-1.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-firewall-spoke-1" {
  name                   = "route-to-firewal-spoke-1l"
  resource_group_name    = azurerm_resource_group.rg-spoke-1.name
  route_table_name       = azurerm_route_table.route-table-spoke-1.name
  address_prefix         = azurerm_virtual_network.vnet-spoke-2.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "association-route-table-subnet-vm-spoke-1" {
  subnet_id      = azurerm_subnet.subnet-vm-spoke-1.id
  route_table_id = azurerm_route_table.route-table-spoke-1.id
}