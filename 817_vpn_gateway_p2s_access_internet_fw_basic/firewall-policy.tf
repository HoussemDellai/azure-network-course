resource "azurerm_firewall_policy" "firewall-policy-basic" {
  name                = "firewall-policy-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
}

resource "azurerm_firewall_policy_rule_collection_group" "policy-group-allow-basic" {
  name               = "policy-group-allow-basic"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy-basic.id
  priority           = 100

  application_rule_collection {
    name     = "application-rule-allow-all"
    priority = 100
    action   = "Allow"

    rule {
      name              = "allow-internet"
      source_addresses  = ["*"]
      destination_fqdns = ["*"]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "network-rule-allow-all"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "allow-internet"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    }
  }

  # nat_rule_collection {
  #   name     = "nat_rule_collection1"
  #   priority = 300
  #   action   = "Dnat"
  #   rule {
  #     name                = "nat_rule_collection1_rule1"
  #     protocols           = ["TCP", "UDP"]
  #     source_addresses    = ["*"]
  #     destination_address = azurerm_public_ip.transitip.ip_address
  #     destination_ports   = ["3389"]
  #     translated_address  = "10.10.11.4"
  #     translated_port     = "3389"
  #   }
  # }
}

