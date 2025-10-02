resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-analytics-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018" # PerGB2018, Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation
  retention_in_days   = 30          # possible values are either 7 (Free Tier only) or range between 30 and 730
}

resource "azurerm_log_analytics_solution" "windows_event_forwarding" {
  solution_name         = "WindowsEventForwarding"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/WindowsEventForwarding"
  }
}

# resource "azurerm_log_analytics_solution" "solution" {
#   provider              = azurerm.subscription_hub
#   solution_name         = "ContainerInsights"
#   location              = azurerm_log_analytics_workspace.law.location
#   resource_group_name   = azurerm_log_analytics_workspace.law.resource_group_name
#   workspace_resource_id = azurerm_log_analytics_workspace.law.id
#   workspace_name        = azurerm_log_analytics_workspace.law.name
#   tags                  = var.tags

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ContainerInsights"
#   }
# }