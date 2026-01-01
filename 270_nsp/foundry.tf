resource "azurerm_cognitive_account" "foundry" {
  name                               = "foundry-${var.prefix}"
  location                           = azurerm_resource_group.rg.location
  resource_group_name                = azurerm_resource_group.rg.name
  kind                               = "AIServices"
  sku_name                           = "S0"
  project_management_enabled         = true
  custom_subdomain_name              = "foundry-${var.prefix}"
  local_auth_enabled                 = true # false # true
  public_network_access_enabled      = true
  outbound_network_access_restricted = false

  identity {
    type = "SystemAssigned"
  }

  tags = {
    SecurityControl = "Ignore"
    CostControl     = "Ignore"
  }
}

resource "azurerm_cognitive_account_project" "project" {
  name                 = "project-${var.prefix}"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = azurerm_cognitive_account.foundry.location
  description          = "Example cognitive services project"
  display_name         = "Example Project"

  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_role_assignment" "ai-services" {
#   scope                = azurerm_cognitive_account.foundry.id
#   role_definition_name = "Cognitive Services OpenAI Contributor" # "Cognitive Services OpenAI User"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# # Azure AI User
# resource "azurerm_role_assignment" "ai-user" {
#   scope                = azurerm_cognitive_account.foundry.id
#   role_definition_name = "Azure AI User"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# # Azure AI Project Manager
# resource "azurerm_role_assignment" "ai-project-manager" {
#   scope                = azurerm_cognitive_account_project.project.id
#   role_definition_name = "Azure AI Project Manager"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# # # Your project, "ai-project" does not have permission to access the connected Azure OpenAI resource because its connection is set to use role-based authentication. To resolve this issue, you can either assign the role of Azure AI Developer to your project for the resource, or change the connection's authentication method to use an API key and try again. If you recently added the role, it could take up to 15 minutes for the roles to update.
# # resource "azurerm_role_assignment" "azure-ai-developer-project-on-ai-services" {
# #   scope                = azurerm_ai_services.ai-services.id
# #   role_definition_name = "Azure AI Developer"
# #   principal_id         = azurerm_ai_foundry_project.ai-foundry-project.identity.0.principal_id # azapi_resource.project.identity.0.principal_id
# # }

output "foundry_endpoint" {
  value = azurerm_cognitive_account.foundry.endpoint
}

output "foundry_primary_access_key" {
  value     = azurerm_cognitive_account.foundry.primary_access_key
  sensitive = true
}
