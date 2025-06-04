resource "azurerm_route_table" "rt-not-routed" {
  name                          = "rt-not-routed"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-spoke-firewall" {
  name                   = "route-to-spoke-firewall"
  route_table_name       = azurerm_route_table.rt-not-routed.name
  resource_group_name    = azurerm_route_table.rt-not-routed.resource_group_name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall-basic.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "association-rt-snet-not-routed" {
  subnet_id      = azurerm_subnet.snet-not-routed-aks.id
  route_table_id = azurerm_route_table.rt-not-routed.id
}