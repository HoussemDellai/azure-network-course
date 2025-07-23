resource "azurerm_virtual_hub_routing_intent" "routing-intent-vhub01" {
  name           = "routing-intent-vhub01"
  virtual_hub_id = azurerm_virtual_hub.vhub01.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.firewall-hub01.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.firewall-hub01.id
  }
}
