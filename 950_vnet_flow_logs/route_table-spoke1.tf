resource "azurerm_route_table" "route-table-spoke1" {
  name                          = "route-table-spoke1"
  location                      = azurerm_resource_group.rg-spoke1.location
  resource_group_name           = azurerm_resource_group.rg-spoke1.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-firewall-spoke1" {
  name                   = "route-to-firewal-spoke1"
  resource_group_name    = azurerm_resource_group.rg-spoke1.name
  route_table_name       = azurerm_route_table.route-table-spoke1.name
  address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-spoke.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_linux_virtual_machine.vm-hub-nva.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route-table-spoke1" {
  subnet_id      = azurerm_subnet.subnet-spoke1-vm.id
  route_table_id = azurerm_route_table.route-table-spoke1.id
}