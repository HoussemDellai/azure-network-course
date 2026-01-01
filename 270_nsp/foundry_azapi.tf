# resource "azapi_resource" "foundry" {
#   type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
#   name                      = "foundry-${var.prefix}"
#   parent_id                 = azurerm_resource_group.rg.id
#   location                  = azurerm_resource_group.rg.location
#   schema_validation_enabled = false

#   body = {
#     kind = "AIServices"
#     sku = {
#       name = "S0"
#     }

#     identity = {
#       type = "SystemAssigned"
#     }

#     properties = {
#       disableLocalAuth       = false
#       allowProjectManagement = true
#       customSubDomainName    = "foundry-${var.prefix}"
#       publicNetworkAccess    = "Enabled"
#     }
#   }
# }

# resource "azapi_resource" "foundry_project" {
#   type                      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
#   name                      = "project-${var.prefix}"
#   parent_id                 = azapi_resource.foundry.id
#   location                  = azurerm_resource_group.rg.location
#   schema_validation_enabled = false

#   body = {
#     sku = {
#       name = "S0"
#     }

#     identity = {
#       type = "SystemAssigned"
#     }

#     properties = {
#       displayName = "project"
#       description = "My first project"
#     }
#   }
# }

# resource "azurerm_cognitive_deployment" "gpt_52_azapi" {
#   name                 = "gpt-5.2"
#   cognitive_account_id = azapi_resource.foundry.id

#   sku {
#     name     = "GlobalStandard" # "Standard" # DataZoneStandard, GlobalBatch, GlobalStandard and ProvisionedManaged
#     capacity = 10
#   }

#   model {
#     format  = "OpenAI"
#     name    = "gpt-5.2"
#     version = "2025-12-11"
#   }
# }

# # output "foundry_endpoint" {
# #   value = azapi_resource.foundry.output.properties.endpoint
# # }

# # output "foundry_primary_access_key" {
# #   value     = azapi_resource.foundry.output.properties.primaryAccessKey
# #   sensitive = true
# # }
