resource "azurerm_virtual_hub_routing_intent" "routing-intent-vhub02" {
  name           = "routing-intent-vhub02"
  virtual_hub_id = azurerm_virtual_hub.vhub02.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.firewall-hub02.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.firewall-hub02.id
  }
}
