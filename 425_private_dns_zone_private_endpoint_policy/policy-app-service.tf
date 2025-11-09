resource "azurerm_resource_group_policy_assignment" "policy-app-service" {
  name                 = "policy-app-service"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452"
  resource_group_id    = azurerm_resource_group.rg.id
  enforce              = true
  location             = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    privateDnsZoneId = {
      value = azurerm_private_dns_zone.private-dns-zone-app-service.id
    }
    effect = {
      value = "DeployIfNotExists"
    }
  })
}

resource "azurerm_resource_group_policy_remediation" "remediation-app-service" {
  name                 = "remediation-app-service"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_assignment_id = azurerm_resource_group_policy_assignment.policy-app-service.id
}

resource "azurerm_role_assignment" "role-network-contributor-policy-app-service" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.policy-app-service.identity.0.principal_id
}
