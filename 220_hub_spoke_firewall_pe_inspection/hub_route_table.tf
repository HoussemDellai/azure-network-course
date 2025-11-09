resource "azurerm_route_table" "route-table-to-nva-hub" {
  name                          = "route-table-to-nva-hub"
  location                      = azurerm_resource_group.rg-hub.location
  resource_group_name           = azurerm_resource_group.rg-hub.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-nva-hub" {
  name                   = "route-to-nva-hub"
  resource_group_name    = azurerm_resource_group.rg-hub.name
  route_table_name       = azurerm_route_table.route-table-to-nva-hub.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_route" "route-to-nva-hub-pe" {
  name                   = "route-to-nva-hub-pe"
  resource_group_name    = azurerm_resource_group.rg-hub.name
  route_table_name       = azurerm_route_table.route-table-to-nva-hub.name
  address_prefix         = azurerm_subnet.snet-spoke2-pe.address_prefixes[0] # "10.2.0.0/16" #  # "${azurerm_private_endpoint.pe-aca-environment.private_service_connection.0.private_ip_address}/32"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "association_route_table_snet_hub_vm" {
  subnet_id      = azurerm_subnet.snet-hub-vm.id
  route_table_id = azurerm_route_table.route-table-to-nva-hub.id
}
