# resource "azurerm_virtual_hub_routing_intent" "routing-intent-hub02" {
#   name           = "routing-intent-hub02"
#   virtual_hub_id = azurerm_virtual_hub.vhub-02.id

#   routing_policy {
#     name         = "InternetTrafficPolicy"
#     destinations = ["Internet"]
#     next_hop     = azurerm_firewall.firewall-hub-02.id
#   }

#   routing_policy {
#     name         = "PrivateTrafficPolicy"
#     destinations = ["PrivateTraffic"]
#     next_hop     = azurerm_firewall.firewall-hub-02.id
#   }
# }