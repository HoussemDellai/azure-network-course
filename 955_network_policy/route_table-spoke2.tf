resource "azurerm_route_table" "route-table-spoke2" {
  name                          = "route-table-spoke2"
  location                      = azurerm_resource_group.rg-spoke2.location
  resource_group_name           = azurerm_resource_group.rg-spoke2.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-firewall-spoke2" {
  name                   = "route-to-firewal-spoke2"
  resource_group_name    = azurerm_resource_group.rg-spoke2.name
  route_table_name       = azurerm_route_table.route-table-spoke2.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address # azurerm_linux_virtual_machine.vm-hub-nva.private_ip_address
}

# need to specify the route to the private endpoint
resource "azurerm_route" "route-to-firewall-pe" {
  name                   = "route-to-firewal-pe"
  resource_group_name    = azurerm_resource_group.rg-spoke2.name
  route_table_name       = azurerm_route_table.route-table-spoke2.name
  address_prefix         = "${azurerm_private_endpoint.private-endpoint-mssql.private_service_connection.0.private_ip_address}/32"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address # azurerm_linux_virtual_machine.vm-hub-nva.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route-table-spoke2" {
  subnet_id      = azurerm_subnet.snet-spoke2-vm.id
  route_table_id = azurerm_route_table.route-table-spoke2.id
}