# This policy works only for : privatelink.cognitiveservices.azure.com
# There is not yet a built-in policy for privatelink.openai.azure.com and privatelink.services.ai.azure.com
resource "azurerm_resource_group_policy_assignment" "policy-ai-services" {
  for_each = toset(local.private-dns-zone-names-ai-services)

  name                 = "policy-ai-services-${each.key}"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091"
  resource_group_id    = azurerm_resource_group.rg.id
  enforce              = true
  location             = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    privateDnsZoneId = {
      value = azurerm_private_dns_zone.private-dns-zone-ai-services[each.key].id
    }
    effect = {
      value = "DeployIfNotExists"
    }
  })
}

resource "azurerm_resource_group_policy_remediation" "remediation-ai-services" {
  for_each = toset(local.private-dns-zone-names-ai-services)

  name                 = "remediation-ai-services-${each.key}"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_assignment_id = azurerm_resource_group_policy_assignment.policy-ai-services[each.key].id
}

resource "azurerm_role_assignment" "role-network-contributor-policy-ai-services" {
  for_each = toset(local.private-dns-zone-names-ai-services)

  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.policy-ai-services[each.key].identity.0.principal_id
}
