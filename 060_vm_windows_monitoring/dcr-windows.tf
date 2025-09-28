resource "azurerm_monitor_data_collection_rule" "dcr_windows" {
  name                = "dcr-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Windows"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }

    azure_monitor_metrics {
      name = "destination-metrics"
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
  }

  # data_flow {
  #   streams      = ["Microsoft-Syslog"]
  #   destinations = ["destination-log"]
  # }

  # data_flow {
  #   streams      = ["Microsoft-Event"]
  #   destinations = ["destination-log"]
  # }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  # data_flow {
  #   streams       = ["Microsoft-Perf"]
  #   destinations  = ["destination-metrics"]
  #   output_stream = "Microsoft-InsightsMetrics"
  # }

  # data_flow {
  #   streams       = ["Custom-MyTableRawData"]
  #   destinations  = ["example-destination-log"]
  #   output_stream = "Microsoft-Syslog"
  #   transform_kql = "source | project TimeGenerated = Time, Computer, Message = AdditionalContext"
  # }

  data_sources {
    windows_event_log {
      name    = "datasource-windows-eventlog"
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]",
        "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
      ]
    }
    # syslog {
    #   facility_names = ["*"] # ["daemon", "syslog"]
    #   log_levels     = ["*"] # ["Warning", "Error", "Critical", "Alert", "Emergency"]
    #   name           = "datasource-syslog"
    #   streams        = ["Microsoft-Syslog"]
    # }

    performance_counter {
      name    = "CustomPerfCounters"
      streams = ["Microsoft-Perf"]
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Processor Information(_Total)\\% Privileged Time",
        "\\Processor Information(_Total)\\% User Time",
        "\\Processor Information(_Total)\\Processor Frequency",
        "\\System\\Processes",
        "\\Process(_Total)\\Thread Count",
        "\\System\\System Up Time",
        "\\System\\Context Switches/sec",
        "\\System\\Processor Queue Length",
        "\\Memory\\% Committed Bytes In Use",
        "\\LogicalDisk(_Total)\\% Disk Time",
        "\\LogicalDisk(_Total)\\% Idle Time",
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Network Interface(*)\\Bytes Sent/sec",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Packets/sec",
        "\\Network Interface(*)\\Packets Sent/sec",
        "\\Network Interface(*)\\Packets Received/sec",
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Committed Bytes",
        "\\LogicalDisk(_Total)\\Free Megabytes",
        "\\PhysicalDisk(_Total)\\Avg. Disk Queue Length"
      ]
      sampling_frequency_in_seconds = 30
    }

    # performance_counter {
    #   name    = "VMInsightsPerfCounters"
    #   streams = ["Microsoft-InsightsMetrics"]
    #   counter_specifiers = [
    #     "\\VmInsights\\DetailedMetrics"
    #   ]
    #   sampling_frequency_in_seconds = 30
    # }

    # log_file {
    #   name          = "datasource-logfile"
    #   format        = "text"
    #   streams       = ["Custom-MyTableRawData"]
    #   file_patterns = ["C:\\JavaLogs\\*.log"]
    #   settings {
    #     text {
    #       record_start_timestamp_format = "ISO 8601"
    #     }
    #   }
    # }

    # extension {
    #   streams            = ["Microsoft-WindowsEvent"]
    #   input_data_sources = ["datasource-windows-eventlog"]
    #   extension_name     = "windows-eventlog"
    #   # extension_json = jsonencode({
    #   #   a = 1
    #   #   b = "hello"
    #   # })
    #   name = "datasource-extension"
    # }
  }

  # stream_declaration {
  #   stream_name = "Custom-MyTableRawData"
  #   column {
  #     name = "Time"
  #     type = "datetime"
  #   }
  #   column {
  #     name = "Computer"
  #     type = "string"
  #   }
  #   column {
  #     name = "AdditionalContext"
  #     type = "string"
  #   }
  # }
}
