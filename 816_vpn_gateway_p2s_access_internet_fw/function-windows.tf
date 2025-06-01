# resource "azurerm_storage_account" "storage" {
#   name                     = "storagefunction7531"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_service_plan" "plan" {
#   name                = "app-service-plan"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   os_type             = "Windows"
#   sku_name            = "Y1"
# }

# resource "azurerm_windows_function_app" "function" {
#   name                       = "function-app-${var.prefix}"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   storage_account_name       = azurerm_storage_account.storage.name
#   storage_account_access_key = azurerm_storage_account.storage.primary_access_key
#   service_plan_id            = azurerm_service_plan.plan.id

#   site_config {
#     application_stack {
#       powershell_core_version = "7.4"
#     }
#   }

#   app_settings = {
#     "Firewall_NAME"           = azurerm_firewall.firewall.name
#     "FIREWALL_RESOURCE_GROUP" = azurerm_resource_group.rg.name
#   }

#   identity {
#     type = "SystemAssigned"
#   }
# }

# # role assignment for function app to stop/start the firewall
# resource "azurerm_role_assignment" "function-contributor-firewall" {
#   principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
#   role_definition_name = "Contributor"
#   scope                = azurerm_firewall.firewall.id
# }

# # required to stop the Firewall
# resource "azurerm_role_assignment" "function-contributor-firewall-policy" {
#   principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
#   role_definition_name = "Contributor"
#   scope                = azurerm_firewall_policy.firewall-policy.id
# }
