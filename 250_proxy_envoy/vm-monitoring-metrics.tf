# resource "azurerm_dashboard_grafana" "grafana" {
#   name                              = "azure-grafana-${var.prefix}"
#   resource_group_name               = azurerm_resource_group.rg.name
#   location                          = azurerm_resource_group.rg.location
#   sku                               = "Standard"
#   grafana_major_version             = "11"
#   zone_redundancy_enabled           = false
#   api_key_enabled                   = true
#   deterministic_outbound_ip_enabled = true
#   public_network_access_enabled     = true

#   azure_monitor_workspace_integrations {
#     resource_id = azurerm_monitor_workspace.prometheus.id
#   }

#   identity {
#     type = "SystemAssigned"
#   }
# }

# data "azurerm_client_config" "current" {}

# resource "azurerm_role_assignment" "role_grafana_admin" {
#   scope                = azurerm_dashboard_grafana.grafana.id
#   role_definition_name = "Grafana Admin"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurerm_role_assignment" "role_monitoring_data_reader" {
#   scope                = azurerm_monitor_workspace.prometheus.id
#   role_definition_name = "Monitoring Data Reader"
#   principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
# }

# data "azurerm_subscription" "current" {}

# resource "azurerm_role_assignment" "role_monitoring_reader" {
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = "Monitoring Reader"
#   principal_id         = azurerm_dashboard_grafana.grafana.identity.0.principal_id
# }

# resource "azurerm_monitor_data_collection_endpoint" "dce-prometheus" {
#   name                          = "dce-prometheus"
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   kind                          = "Linux"
#   public_network_access_enabled = true
# }

# # # not required and causes issue
# # resource "azurerm_monitor_data_collection_rule_association" "dcra-dce-prometheus-vm" {
# #   #   name                        = "configurationAccessEndpoint" # "dcra-dce-prometheus-aks" #  # name is required when data_collection_rule_id is specified. And when data_collection_endpoint_id is specified, the name is populated with configurationAccessEndpoint
# #   target_resource_id          = azurerm_linux_virtual_machine.vm-linux.id
# #   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce-prometheus.id
# # }

# resource "azurerm_monitor_data_collection_rule" "dcr-prometheus" {
#   name                        = "dcr-prometheus"
#   resource_group_name         = azurerm_resource_group.rg.name
#   location                    = azurerm_resource_group.rg.location
#   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce-prometheus.id
#   kind                        = "Linux"
#   description                 = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"


#   identity {
#     type = "SystemAssigned"
#   }

#   data_sources {
#     prometheus_forwarder {
#       name    = "PrometheusDataSource"
#       streams = ["Microsoft-PrometheusMetrics"]
#     }
#   }

#   destinations {
#     monitor_account {
#       monitor_account_id = azurerm_monitor_workspace.prometheus.id
#       name               = azurerm_monitor_workspace.prometheus.name
#     }
#   }

#   data_flow {
#     streams      = ["Microsoft-PrometheusMetrics"]
#     destinations = [azurerm_monitor_workspace.prometheus.name]
#   }
# }

# resource "azurerm_monitor_data_collection_rule_association" "dcra-dcr-prometheus-vm" {
#   name                    = "dcra-dcr-prometheus-vm"
#   target_resource_id      = azurerm_linux_virtual_machine.vm-linux.id
#   data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr-prometheus.id
#   description             = "Association of DCR. Deleting this association will break the data collection for this VM."
# }

# resource "azurerm_monitor_workspace" "prometheus" {
#   name                          = "azure-prometheus"
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   public_network_access_enabled = true
# }

# resource "azurerm_role_assignment" "role_monitoring_data_reader_me" {
#   scope                = azurerm_monitor_workspace.prometheus.id
#   role_definition_name = "Monitoring Data Reader"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurerm_role_assignment" "role_monitoring_metrics_publisher" {
#   scope                = azurerm_monitor_data_collection_rule.dcr-prometheus.id
#   role_definition_name = "Monitoring Metrics Publisher"
#   principal_id         = azurerm_linux_virtual_machine.vm-linux.identity.0.principal_id
# }