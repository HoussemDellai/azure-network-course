# resource "azurerm_virtual_hub_routing_intent" "routing-intent-hub01" {
#   name           = "routing-intent-hub01"
#   virtual_hub_id = azurerm_virtual_hub.vhub-01.id

#   routing_policy {
#     name         = "InternetTrafficPolicy"
#     destinations = ["Internet"]
#     next_hop     = azurerm_firewall.firewall-hub-01.id
#   }

#   routing_policy {
#     name         = "PrivateTrafficPolicy"
#     destinations = ["PrivateTraffic"]
#     next_hop     = azurerm_firewall.firewall-hub-01.id
#   }
# }