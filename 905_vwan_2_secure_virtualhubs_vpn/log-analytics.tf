resource "azurerm_log_analytics_workspace" "log-analytics" {
  name                = "log-analytics"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = -1
}

data "azurerm_monitor_diagnostic_categories" "categories" {
  resource_id = azurerm_firewall.firewall-hub01.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics-firewall-hub01" {
  name                           = "diagnostics-firewall-hub01"
  target_resource_id             = azurerm_firewall.firewall-hub01.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log-analytics.id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.log_category_types

    content {
      category = enabled_log.key
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.metrics

    content {
      category = enabled_metric.key
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics-firewall-hub02" {
  name                           = "diagnostics-firewall-hub02"
  target_resource_id             = azurerm_firewall.firewall-hub02.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log-analytics.id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.log_category_types

    content {
      category = enabled_log.key
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.metrics

    content {
      category = enabled_metric.key
    }
  }
}
