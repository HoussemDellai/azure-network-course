resource "azurerm_resource_group_policy_assignment" "policy-storage-account" {
  name                 = "policy-storage-account"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
  resource_group_id    = azurerm_resource_group.rg.id
  enforce              = true
  location             = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    privateDnsZoneId = {
      value = azurerm_private_dns_zone.private-dns-zone-storage-account.id
    }
    effect = {
      value = "DeployIfNotExists"
    }
  })
}

resource "azurerm_resource_group_policy_remediation" "remediation-storage-account" {
  name                 = "remediation-storage-account"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_assignment_id = azurerm_resource_group_policy_assignment.policy-storage-account.id
}

resource "azurerm_role_assignment" "role-network-contributor-policy-storage-account" {
  scope                = azurerm_private_dns_zone.dns-zone-storage-account.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.policy-storage-account.identity.0.principal_id
}