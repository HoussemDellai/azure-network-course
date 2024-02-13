# resource "azurerm_log_analytics_workspace" "log_analytics" {
#   name                = "log-analytics"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   daily_quota_gb      = -1
# }

# data "azurerm_monitor_diagnostic_categories" "categories" {
#   resource_id = azurerm_firewall.firewall.id
# }

# resource "azurerm_monitor_diagnostic_setting" "diagnostics_firewall" {
#   name               = "diagnostics-firewall"
#   target_resource_id = azurerm_firewall.firewall.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
#   log_analytics_destination_type = "AzureDiagnostics"


#   dynamic "enabled_log" {
#     for_each = data.azurerm_monitor_diagnostic_categories.categories.log_category_types

#     content {
#       category = enabled_log.key
#     }
#   }

#   dynamic "metric" {
#     for_each = data.azurerm_monitor_diagnostic_categories.categories.metrics

#     content {
#       category = metric.key
#     }
#   }

#   lifecycle {
#     ignore_changes = [
#       log_analytics_destination_type
#     ]
#   }
# }