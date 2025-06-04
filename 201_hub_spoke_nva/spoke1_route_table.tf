resource "azurerm_route_table" "route-table-to-nva-spoke1" {
  name                          = "route-table-to-nva-spoke1"
  location                      = azurerm_resource_group.rg-spoke1.location
  resource_group_name           = azurerm_resource_group.rg-spoke1.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

resource "azurerm_route" "route-to-nva-spoke1" {
  name                   = "route-to-nva-spoke1"
  resource_group_name    = azurerm_resource_group.rg-spoke1.name
  route_table_name       = azurerm_route_table.route-table-to-nva-spoke1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vm-hub-nva.vm_private_ip
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_spoke1" {
  subnet_id      = azurerm_subnet.subnet-spoke1-workload.id
  route_table_id = azurerm_route_table.route-table-to-nva-spoke1.id
}
