# resource "azurerm_virtual_hub_route_table" "vhub-02-routetable" {
#   name           = "vhub-02-routetable"
#   virtual_hub_id = azurerm_virtual_hub.vhub-02.id
#   labels         = ["VNet"]

#   route {
#     name              = "snetToFirewall02"
#     destinations_type = "CIDR"
#     destinations      = ["10.0.0.0/8"] # ["10.11.0.0/16", "10.12.0.0/16"]
#     next_hop_type     = "ResourceId"
#     next_hop          = azurerm_firewall.firewall-hub-02.id
#   }

#   # route {
#   #   name              = "snetToFirewall02"
#   #   destinations_type = "CIDR"
#   #   destinations      = ["10.21.0.0/16"]
#   #   next_hop_type     = "ResourceId"
#   #   next_hop          = azurerm_firewall.firewall-hub-02.id
#   # }

#   route {
#     name              = "all-to-firewall"
#     destinations_type = "CIDR"
#     destinations      = ["0.0.0.0/0"]
#     next_hop_type     = "ResourceId"
#     next_hop          = azurerm_firewall.firewall-hub-02.id
#   }
# }
