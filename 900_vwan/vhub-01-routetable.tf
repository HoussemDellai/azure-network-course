resource "azurerm_virtual_hub_route_table" "vhub-01-routetable" {
  name           = "vhub-01-routetable"
  virtual_hub_id = azurerm_virtual_hub.vhub-01.id
  labels         = ["VNet"]

  route {
    name              = "snetToFirewall"
    destinations_type = "CIDR"
    destinations      = ["10.12.0.0/16"]
    next_hop_type     = "ResourceId"
    next_hop          = azurerm_firewall.firewall-hub-01.id
  }

  route {
    name              = "InternetToFirewall"
    destinations_type = "CIDR"
    destinations      = ["0.0.0.0/0"]
    next_hop_type     = "ResourceId"
    next_hop          = azurerm_firewall.firewall-hub-01.id
  }
}