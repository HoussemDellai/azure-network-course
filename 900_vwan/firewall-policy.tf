resource "azurerm_firewall_policy" "firewall-policy-hub-01" {
  name                     = "firewall-policy-hub-01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "app_policy_rule_collection_group" {
  name               = "DefaulApplicationtRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy-hub-01.id
  priority           = 300

  application_rule_collection {
    name     = "DefaultApplicationRuleCollection"
    action   = "Allow"
    priority = 100
    rule {
      name        = "Allow-MSFT"
      description = "Allow access to Microsoft.com"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      destination_fqdns = ["*.microsoft.com"]
      terminate_tls     = false
      source_addresses  = ["*"]
    }
  }
}
