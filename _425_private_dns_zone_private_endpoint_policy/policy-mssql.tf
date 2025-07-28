resource "azurerm_subscription_policy_assignment" "policy-mssql" {
  name                 = "policy-mssql"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
  subscription_id      = data.azurerm_subscription.current.id
  enforce              = true
  location             = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.private-dns-zone-mssql.id}"
  },
  "effect": {
    "value": "DeployIfNotExists"
  }
}
PARAMETERS
}

data "azurerm_subscription" "current" {}

# # role assignment for the policy assignment
# resource "azurerm_role_assignment" "role-policy-mssql" {
#   scope                = azurerm_subscription_policy_assignment.policy-mssql.id
#   role_definition_name = "Policy Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
