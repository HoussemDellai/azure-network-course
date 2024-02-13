# resource "azurerm_firewall_policy" "firewall-policy" {
#   name                = "firewall-policy"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "Standard" # "Basic" # "Standard" # "Premium" #

#   explicit_proxy {
#     enabled         = true
#     http_port       = 8080
#     https_port      = 8443
#     enable_pac_file = false
#     pac_file_port   = null
#     pac_file        = null
#   }
# }

# resource "azurerm_firewall_policy_rule_collection_group" "policy-group-allow" {
#   name               = "policy-group-allow"
#   firewall_policy_id = azurerm_firewall_policy.firewall-policy.id
#   priority           = 100

#   application_rule_collection {
#     name     = "allow-internet"
#     priority = 100
#     action   = "Allow"

#     rule {
#       name              = "allow-internet"
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
# }
