resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                            = "log-analytics"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  sku                             = "PerGB2018"
  allow_resource_only_permissions = false
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  retention_in_days               = 30
  daily_quota_gb                  = -1
}

data "azurerm_monitor_diagnostic_categories" "categories-firewall" {
  resource_id = azurerm_firewall.firewall.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_firewall" {
  name                           = "diagnostics-firewall"
  target_resource_id             = azurerm_firewall.firewall.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "Dedicated" # "AzureDiagnostics"


  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-firewall.log_category_types

    content {
      category = enabled_log.key
    }
  }

<<<<<<< HEAD
  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-firewall.metrics

    content {
      category = enabled_metric.key
=======
  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-firewall.metrics

    content {
      category = metric.key
>>>>>>> a26231ceb327f6bd30df487e9393348a0f3f689f
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}

data "azurerm_monitor_diagnostic_categories" "categories-vpngateway" {
  resource_id = azurerm_virtual_network_gateway.vpn-gateway.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics-vpngateway" {
  name                           = "diagnostics-vpngateway"
  target_resource_id             = azurerm_virtual_network_gateway.vpn-gateway.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "Dedicated" # "AzureDiagnostics"

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-vpngateway.log_category_types

    content {
      category = enabled_log.key
    }
  }

<<<<<<< HEAD
  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-vpngateway.metrics

    content {
      category = enabled_metric.key
=======
  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-vpngateway.metrics

    content {
      category = metric.key
>>>>>>> a26231ceb327f6bd30df487e9393348a0f3f689f
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}