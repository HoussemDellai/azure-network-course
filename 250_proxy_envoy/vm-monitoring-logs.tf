resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-analytics"
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

resource "azurerm_virtual_machine_extension" "ama_linux" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm-linux.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = "dce"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  name                = "dcr-linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"

  identity {
    type = "SystemAssigned"
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }

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

  data_flow {
    streams       = ["Custom-Json-MyTable_CL"]
    destinations  = ["destination-log"]
    output_stream = "Custom-MyTable_CL"
    #     transform_kql = <<EOT
    #     source
    #     | project TimeGenerated = now(),
    #               Computer = "",
    #               FilePath = "",
    #               Message = "",
    #               Level = "",
    #               SourceLine = "",
    #               ThreadId = 0,
    #               RawData = "",
    #               FixedValue = ""
    #   EOT

    transform_kql = "source"
    # transform_kql = "source | project TimeGenerated = Timestamp, ThreadId, SourceLine, Level, Message, FixedValue"
    # transform_kql = "source | project TimeGenerated = now()" # "source | project TimeGenerated = Time, Computer, Message = AdditionalContext"
    # transform_kql = "source | project TimeGenerated = now() | project LogMessage = 'RawData'" # "source | project TimeGenerated = Time, Computer, Message = AdditionalContext"
    # transform_kql = "source | project d = split(RawData,",") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])"
  }

  data_sources {
    syslog {
      facility_names = ["*"] # ["daemon", "syslog"]
      log_levels     = ["*"] # ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }

    log_file {
      name          = "Custom-Json-MyTable_CL"
      format        = "json"
      streams       = ["Custom-Json-MyTable_CL"]
      file_patterns = ["/var/log/envoy.log", "/var/log/envoy_admin_access.log"]
    }

    performance_counter {
      name    = "CustomPerfCounters"
      streams = ["Microsoft-Perf"]
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Processor(*)\\% Idle Time",
        "Processor(*)\\% User Time",
        "Memory(*)\\Available MBytes Memory",
        "Memory(*)\\Used Memory MBytes",
        "Logical Disk(*)\\Free Megabytes",
        "Logical Disk(*)\\% Free Space",
        "Logical Disk(*)\\% Used Space",
        "Network(*)\\Total Packets Transmitted",
        "Network(*)\\Total Packets Received",
        "System(*)\\Uptime",
        "System(*)\\Unique Users",
        "System(*)\\CPUs"
      ]
      sampling_frequency_in_seconds = 30
    }
  }

  stream_declaration {
    stream_name = "Custom-Json-MyTable_CL"
    column {
      name = "TimeGenerated"
      type = "datetime"
    }
    column {
      name = "Computer"
      type = "string"
    }
    column {
      name = "FilePath"
      type = "string"
    }
    # column {
    #   name = "RawData"
    #   type = "string"
    # }
    column {
      name = "Message"
      type = "string"
    }
    column {
      name = "Level"
      type = "string"
    }
    column {
      name = "SourceLine"
      type = "string"
    }
    column {
      name = "ThreadId"
      type = "string"
    }
    # column {
    #   name = "FixedValue"
    #   type = "string"
    # }
  }
}

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

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dce" {
  target_resource_id          = azurerm_linux_virtual_machine.vm-linux.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  description                 = "DCR association for vm linux and DCE"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dcr" {
  name                    = "dcr-association-vm-linux-dcr"
  target_resource_id      = azurerm_linux_virtual_machine.vm-linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_linux.id
  description             = "DCR association for vm linux and DCR"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dcr_vm_insights" {
  name                    = "dcr-association-vm-linux-dcr-vm-insights"
  target_resource_id      = azurerm_linux_virtual_machine.vm-linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_vm_insights.id
  description             = "DCR association for vm linux and DCR vm insights"
}
