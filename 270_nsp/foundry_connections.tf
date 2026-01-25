resource "azapi_resource" "connection_foundry_app_insights" {
  type                      = "Microsoft.CognitiveServices/accounts/connections@2025-06-01"
  name                      = "connection-foundry-app-insights"
  parent_id                 = azurerm_cognitive_account.foundry.id
  schema_validation_enabled = false

  body = {
    properties = {
      authType                    = "ApiKey",
      category                    = "AppInsights",
      target                      = azurerm_application_insights.app_insights.id,
      useWorkspaceManagedIdentity = false,
      isSharedToAll               = false,
      sharedUserList              = [],
      peRequirement               = "NotRequired",
      peStatus                    = "NotApplicable",
    }
  }
  sensitive_body = {
    properties = {
      credentials = {
        key = azurerm_application_insights.app_insights.instrumentation_key
      }
    }
  }
}
