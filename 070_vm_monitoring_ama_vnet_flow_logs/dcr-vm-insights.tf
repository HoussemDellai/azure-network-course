resource "azurerm_monitor_data_collection_rule" "dcr_vm_insights" {
  name                = "dcr-vm-insights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }
  }

  data_sources {
    performance_counter {
      name                          = "VMInsightsPerfCounters"
      streams                       = ["Microsoft-InsightsMetrics"]
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      sampling_frequency_in_seconds = 60
    }

    extension {
      name           = "DependencyAgentDataSource"
      extension_name = "DependencyAgent"
      streams        = ["Microsoft-ServiceMap"]
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-log"]
  }

  data_flow {
    streams      = ["Microsoft-ServiceMap"]
    destinations = ["destination-log"]
  }
}
