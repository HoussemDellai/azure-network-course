# resource "azurerm_route_table" "route_table" {
#   name                          = "route-table"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   disable_bgp_route_propagation = true
# }

# resource "azurerm_route" "route-to-firewall" {
#   name                   = "route-to-firewal"
#   resource_group_name    = azurerm_resource_group.rg.name
#   route_table_name       = azurerm_route_table.route_table.name
#   address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-hub.address_space.0
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
# }

# resource "azurerm_subnet_route_table_association" "association-route-table-subnet-vm-spoke-1" {
#   subnet_id      = azurerm_subnet.subnet-vm.id
#   route_table_id = azurerm_route_table.route_table.id
# }