resource "azurerm_subscription_policy_assignment" "policy-mssql" {
  name                 = "policy-mssql"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4"
  subscription_id      = data.azurerm_subscription.current.id
  enforce              = true

  #   identity {
  #     type = "SystemAssigned"
  #   }

  parameters = <<PARAMETERS
{
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.private-dns-zone-mssql.id}"
  }
}
PARAMETERS
}

data "azurerm_subscription" "current" {}
