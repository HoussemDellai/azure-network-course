# # -------------------------------------------------------------------------
# # 1/2. Override default /32 route for Private Endpoint to point to Firewall
# # -------------------------------------------------------------------------

# resource "azurerm_route" "route-to-nva-hub-pe-override" {
#   name                   = "route-to-nva-hub-pe-override"
#   resource_group_name    = azurerm_resource_group.rg-hub.name
#   route_table_name       = azurerm_route_table.route-table-to-nva-hub.name
#   address_prefix         = "${azurerm_private_endpoint.pe-aca-environment.private_service_connection.0.private_ip_address}/32"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
# }

# resource "azurerm_firewall_policy" "firewall-policy" {
#   name                = "firewall-policy"
#   resource_group_name = azurerm_resource_group.rg-hub.name
#   location            = azurerm_resource_group.rg-hub.location
#   sku                 = "Standard"
#   # private_ip_ranges   = ["255.255.255.255/32"] # enable SNAT
# }

# # ---------------------------------------------------------------------------
# # 2/2. Enable SNAT for Private Endpoint traffic by applying Application Rules
# # ---------------------------------------------------------------------------

# resource "azurerm_firewall_policy_rule_collection_group" "policy-group-allow" {
#   name               = "policy-group-allow"
#   firewall_policy_id = azurerm_firewall_policy.firewall-policy.id
#   priority           = 1000

#   application_rule_collection {
#     name     = "allow-all"
#     priority = 600
#     action   = "Allow"

#     rule {
#       name              = "allow-all"
#       source_addresses  = ["*"]
#       destination_fqdns = ["*"]
#       protocols {
#         type = "Http"
#         port = 80
#       }
#       protocols {
#         type = "Https"
#         port = 443
#       }
#     }
#   }

#   # network_rule_collection {
#   #   name     = "allow-all"
#   #   priority = 500
#   #   action   = "Allow"

#   #   rule {
#   #     name                  = "allow-all"
#   #     protocols             = ["Any"]
#   #     source_addresses      = ["*"]
#   #     destination_addresses = ["*"]
#   #     destination_ports     = ["*"]
#   #   }
#   # }
# }

# resource "azurerm_subnet" "snet-spoke2-pe" {
#   name                              = "snet-spoke2-pe"
#   virtual_network_name              = azurerm_virtual_network.vnet-spoke2.name
#   resource_group_name               = azurerm_virtual_network.vnet-spoke2.resource_group_name
#   address_prefixes                  = ["10.2.1.0/24"]
#   private_endpoint_network_policies = "Disabled"
# }
