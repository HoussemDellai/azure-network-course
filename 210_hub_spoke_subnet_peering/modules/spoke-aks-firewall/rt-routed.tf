resource "azurerm_route_table" "rt-routed" {
  name                          = "rt-routed"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-hub-firewall" {
  name                   = "route-to-hub-firewall"
  route_table_name       = azurerm_route_table.rt-routed.name
  resource_group_name    = azurerm_route_table.rt-routed.resource_group_name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.hub_firewall_private_ip_address
}

resource "azurerm_route" "route-to-hub-firewall-2" {
  name                   = "route-to-hub-firewall-2"
  route_table_name       = azurerm_route_table.rt-routed.name
  resource_group_name    = azurerm_route_table.rt-routed.resource_group_name
  address_prefix         = var.snet_hub_firewall_cidr
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.hub_firewall_private_ip_address
}

resource "azurerm_subnet_route_table_association" "association-rt-snet-routed" {
  subnet_id      = azurerm_subnet.snet-routed-firewall.id
  route_table_id = azurerm_route_table.rt-routed.id
}