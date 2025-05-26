resource "azurerm_route_table" "rt-vpn-gateway" {
  name                          = "rt-vpn-gateway"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-to-nva-0-127" {
  name                   = "route-to-nva-0-127"
  route_table_name       = azurerm_route_table.rt-vpn-gateway.name
  resource_group_name    = azurerm_route_table.rt-vpn-gateway.resource_group_name
  address_prefix         = "0.0.0.0/1"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.nic-vm-nva.private_ip_address # azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_route" "route-to-nva-128-255" {
  name                   = "route-to-nva-128-255"
  route_table_name       = azurerm_route_table.rt-vpn-gateway.name
  resource_group_name    = azurerm_route_table.rt-vpn-gateway.resource_group_name
  address_prefix         = "128.0.0.0/1"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.nic-vm-nva.private_ip_address # azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "rt-vpn-gateway-snet" {
  subnet_id      = azurerm_subnet.snet-gateway.id
  route_table_id = azurerm_route_table.rt-vpn-gateway.id
}