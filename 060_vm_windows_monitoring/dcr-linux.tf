resource "azurerm_monitor_data_collection_rule" "dcr-linux" {
  name                = "dcr-linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }

    # event_hub {
    #   event_hub_id = azurerm_eventhub.example.id
    #   name         = "example-destination-eventhub"
    # }

    # storage_blob {
    #   storage_account_id = azurerm_storage_account.example.id
    #   container_name     = azurerm_storage_container.example.name
    #   name               = "example-destination-storage"
    # }

    azure_monitor_metrics {
      name = "destination-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["destination-log"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  data_sources {
    syslog {
      facility_names = ["*"] # ["daemon", "syslog"]
      log_levels     = ["*"] # ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }

    log_file {
      name          = "datasource-logfile"
      format        = "text"
      streams       = ["Custom-MyTableRawData"]
      file_patterns = ["C:\\JavaLogs\\*.log"]
      settings {
        text {
          record_start_timestamp_format = "ISO 8601"
        }
      }
    }

    # performance_counter {
    #   name    = "VMInsightsPerfCounters"
    #   streams = ["Microsoft-InsightsMetrics"]
    #   counter_specifiers = [
    #     "\\VmInsights\\DetailedMetrics"
    #   ]
    #   sampling_frequency_in_seconds = 30
    # }
  }
}
