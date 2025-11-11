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


# # ---------------------------------------------------------------------------
# # 2/2. Enable SNAT for Private Endpoint traffic in Firewall Policy
# # ---------------------------------------------------------------------------

# resource "azurerm_firewall_policy" "firewall-policy" {
#   name                = "firewall-policy"
#   resource_group_name = azurerm_resource_group.rg-hub.name
#   location            = azurerm_resource_group.rg-hub.location
#   sku                 = "Standard"
#   private_ip_ranges   = ["255.255.255.255/32"] # enable SNAT
# }

# resource "azurerm_firewall_policy_rule_collection_group" "policy-group-allow" {
#   name               = "policy-group-allow"
#   firewall_policy_id = azurerm_firewall_policy.firewall-policy.id
#   priority           = 1000

#   network_rule_collection {
#     name     = "allow-all"
#     priority = 500
#     action   = "Allow"

#     rule {
#       name                  = "allow-all"
#       protocols             = ["Any"]
#       source_addresses      = ["*"]
#       destination_addresses = ["*"]
#       destination_ports     = ["*"]
#     }
#   }
# }

# resource "azurerm_subnet" "snet-spoke2-pe" {
#   name                 = "snet-spoke2-pe"
#   virtual_network_name = azurerm_virtual_network.vnet-spoke2.name
#   resource_group_name  = azurerm_virtual_network.vnet-spoke2.resource_group_name
#   address_prefixes     = ["10.2.1.0/24"]
#   private_endpoint_network_policies = "Disabled"
# }

# # azureuser@vm-linux-hub:~$ traceroute 10.2.1.4
# # traceroute to 10.2.1.4 (10.2.1.4), 30 hops max, 60 byte packets
# #  1  gsa-3ffb3f06-b17b000001.internal.cloudapp.net (172.16.0.6)  1.346 ms gsa-3ffb3f06-b17b000000.internal.cloudapp.net (172.16.0.5)  4.125 ms gsa-3ffb3f06-b17b000001.internal.cloudapp.net (172.16.0.6)  1.497 ms
# #  2  * * *
# #  3  * * *


# # azureuser@vm-linux-hub:~$ curl 10.2.1.4/api/introspector --header 'Host: inspector-gadget.bravesea-d2096df3.swedencentral.azurecontainerapps.io' | jq .request[7]
# #   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
# #                                  Dload  Upload   Total   Spent    Left  Speed
# # 100 13497    0 13497    0     0  1291k      0 --:--:-- --:--:-- --:--:-- 1318k
# # {
# #   "key": "remote-ipaddress",
# #   "displayName": "Remote IP Address",
# #   "value": "::ffff:100.100.0.89"
# # }