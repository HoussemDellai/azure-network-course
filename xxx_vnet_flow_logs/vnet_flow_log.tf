# network watcher is created by default

data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_${azurerm_resource_group.rg-hub.location}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_watcher_flow_log" "nsg-flowlogs-hub" {
  name                      = "nsg-flowlogs-hub"
  network_watcher_name      = data.azurerm_network_watcher.network_watcher.name
  resource_group_name       = data.azurerm_network_watcher.network_watcher.resource_group_name
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
  storage_account_id        = azurerm_storage_account.sa.id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.workspace.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.workspace.location
    workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
    interval_in_minutes   = 10
  }
}

resource "azurerm_network_watcher_flow_log" "nsg-flowlogs-spoke1" {
  name                      = "nsg-flowlogs-spoke1"
  network_watcher_name      = data.azurerm_network_watcher.network_watcher.name
  resource_group_name       = data.azurerm_network_watcher.network_watcher.resource_group_name
  network_security_group_id = azurerm_network_security_group.nsg-spoke1.id
  storage_account_id        = azurerm_storage_account.sa.id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.workspace.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.workspace.location
    workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
    interval_in_minutes   = 10
  }
}

resource "azurerm_network_watcher_flow_log" "nsg-flowlogs-spoke2" {
  name                      = "nsg-flowlogs-spoke2"
  network_watcher_name      = data.azurerm_network_watcher.network_watcher.name
  resource_group_name       = data.azurerm_network_watcher.network_watcher.resource_group_name
  network_security_group_id = azurerm_network_security_group.nsg-spoke2.id
  storage_account_id        = azurerm_storage_account.sa.id
  version                   = 2
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.workspace.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.workspace.location
    workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
    interval_in_minutes   = 10
  }
}
