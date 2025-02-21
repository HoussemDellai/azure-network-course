resource "azurerm_route_table" "route-table-spoke-2" {
  name                          = "route-table-spoke-2"
  location                      = azurerm_resource_group.rg-spoke-2.location
  resource_group_name           = azurerm_resource_group.rg-spoke-2.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-firewall-spoke-2" {
  name                   = "route-to-firewall-spoke-2"
  resource_group_name    = azurerm_resource_group.rg-spoke-2.name
  route_table_name       = azurerm_route_table.route-table-spoke-2.name
  address_prefix         = azurerm_virtual_network.vnet-spoke-1.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "association-route-table-subnet-vm-spoke-2" {
  subnet_id      = azurerm_subnet.subnet-vm-spoke-2.id
  route_table_id = azurerm_route_table.route-table-spoke-2.id
}