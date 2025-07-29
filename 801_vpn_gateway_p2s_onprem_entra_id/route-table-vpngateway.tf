resource "azurerm_route_table" "route-table-vpngateway" {
  name                          = "route-table-vpngateway"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

# You can configure forced tunneling in order to direct all traffic to the VPN tunnel. 
# Forced tunneling can be configured using two different methods;
# either by advertising custom routes, or by modifying the profile XML file.
# Advertise custom routes: You can advertise custom routes 0.0.0.0/1 and 128.0.0.0/1
# Src: https://learn.microsoft.com/en-us/azure/vpn-gateway/azure-vpn-client-optional-configurations#forced-tunneling
resource "azurerm_route" "route-to-internet-1" {
  name                   = "route-to-internet-1"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route-table-vpngateway.name
  address_prefix         = "0.0.0.0/1"
  next_hop_type          = "Internet"
}

resource "azurerm_route" "route-to-internet-2" {
  name                   = "route-to-internet-2"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route-table-vpngateway.name
  address_prefix         = "128.0.0.0/1"
  next_hop_type          = "Internet"
}

resource "azurerm_subnet_route_table_association" "association-route-table-subnet-gateway" {
  subnet_id      = azurerm_subnet.snet-gateway.id
  route_table_id = azurerm_route_table.route-table-vpngateway.id
}
