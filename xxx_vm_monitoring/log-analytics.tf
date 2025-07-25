resource "azurerm_log_analytics_workspace" "log-analytics" {
  name                = "log-analytics-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = -1
}

# resource "azurerm_log_analytics_workspace_table" "table" {
#   workspace_id            = azurerm_log_analytics_workspace.log-analytics.id
#   name                    = "MyLogs"
#   retention_in_days       = 60
#   total_retention_in_days = 180
#   plan                    = "Analytics"
# }
