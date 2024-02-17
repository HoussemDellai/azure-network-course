resource "azurerm_route_table" "route-table-spoke" {
  name                          = "route-table-spoke"
  location                      = azurerm_resource_group.rg-spoke.location
  resource_group_name           = azurerm_resource_group.rg-spoke.name
  disable_bgp_route_propagation = true
}

resource "azurerm_route" "route-to-firewall-spoke" {
  name                   = "route-to-firewal-spoke"
  resource_group_name    = azurerm_resource_group.rg-spoke.name
  route_table_name       = azurerm_route_table.route-table-spoke.name
  address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-spoke.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_linux_virtual_machine.vm-hub-nva.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route-table-spoke" {
  subnet_id      = azurerm_subnet.subnet-spoke-vm.id
  route_table_id = azurerm_route_table.route-table-spoke.id
}