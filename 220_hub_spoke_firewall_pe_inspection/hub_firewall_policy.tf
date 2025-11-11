# resource "azurerm_firewall_policy" "firewall-policy" {
#   name                = "firewall-policy"
#   resource_group_name = azurerm_resource_group.rg-hub.name
#   location            = azurerm_resource_group.rg-hub.location
#   sku                 = "Standard" # "Basic" # "Standard" # "Premium" #
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

  # application_rule_collection {
  #   name     = "allow-all"
  #   priority = 600
  #   action   = "Allow"

  #   rule {
  #     name              = "allow-all"
  #     source_addresses  = ["*"]
  #     destination_fqdns = ["*"]
  #     protocols {
  #       type = "Http"
  #       port = 80
  #     }
  #     protocols {
  #       type = "Https"
  #       port = 443
  #     }
  #   }
  # }
# }
