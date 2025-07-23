resource "azurerm_firewall_policy" "firewall-policy-hub02" {
  name                     = "firewall-policy-hub02"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.region2
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "policy-firewall-hub02" {
  name               = "policy-firewall-hub02"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy-hub02.id
  priority           = 300

  application_rule_collection {
    name     = "Allow-ifconf.me"
    action   = "Allow"
    priority = 100
    rule {
      name        = "Allow-ifconf.me"
      description = "Allow access to ifconf.me"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      destination_fqdns = ["ifconf.me"]
      terminate_tls     = false
      source_addresses  = ["*"]
    }
  }

  network_rule_collection {
    name     = "Allow-Azure-Internal-Communication"
    action   = "Allow"
    priority = 200
    rule {
      name                  = "Allow-Azure-Internal-Communication"
      description           = "Allow internal communication between Spoke VNets"
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["*"]
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
    }
  }

  network_rule_collection {
    name     = "Allow-OnPrem-to-Azure-Communication"
    action   = "Allow"
    priority = 300
    rule {
      name                  = "Allow-OnPrem-to-Azure-Communication"
      description           = "Allow communication from on-premises to Azure VNets"
      source_addresses      = ["172.16.0.0/12"]
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["*"]
      protocols             = ["TCP", "UDP", "ICMP", "Any"]
    }
  }
}
