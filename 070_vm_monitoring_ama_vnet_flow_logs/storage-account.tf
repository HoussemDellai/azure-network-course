resource "azurerm_storage_account" "storage_account" {
  name                          = "storagevnetflowlogs${var.prefix}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  https_traffic_only_enabled    = true
  public_network_access_enabled = true
  shared_access_key_enabled     = true
}

data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_swedencentral"
  resource_group_name = "NetworkWatcherRG"
}

# NetworkWatcherCountLimitReached: Cannot create more than 1 network watchers for this subscription in this region.
# resource "azurerm_network_watcher" "network_watcher" {
#   name                = "network-watcher"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_network_watcher_flow_log" "flow_log" {
#   network_watcher_name = azurerm_network_watcher.network_watcher.name
#   resource_group_name  = azurerm_resource_group.rg.name
#   name                 = "flow-log"
#   target_resource_id   = azurerm_network_security_group.test.id
#   storage_account_id   = azurerm_storage_account.storage_account.id
#   enabled              = true

#   retention_policy {
#     enabled = true
#     days    = 7
#   }

#   traffic_analytics {
#     enabled               = true
#     workspace_id          = azurerm_log_analytics_workspace.law.workspace_id
#     workspace_region      = azurerm_log_analytics_workspace.law.location
#     workspace_resource_id = azurerm_log_analytics_workspace.law.id
#     interval_in_minutes   = 10
#   }
# }

/*
Note: This is a generated HCL content from the JSON input which is based on the latest API version available.
To import the resource, please run the following command:
terraform import azapi_resource.flowlog ?api-version=2023-09-01

Or add the below config:
import {
  id = "?api-version=2023-09-01"
  to = azapi_resource.flowlog
}
*/

# resource "azapi_resource" "flowlog" {
#   type      = "microsoft.network/networkwatchers/flowlogs@2023-09-01"
#   parent_id = "/subscriptions/$${var.subscriptionId}/resourceGroups/$${var.resourceGroupName}"
#   name      = "vnet-spoke-vm-rg-vm-monitoring-070-flowlog"
#   location  = "[parameters('location')]"
#   body = {
#     properties = {
#       enabled = "[parameters('enabled')]"
#       flowAnalyticsConfiguration = {
#         networkWatcherFlowAnalyticsConfiguration = {
#           enabled                  = "[parameters('trafficAnalyticsEnabled')]"
#           trafficAnalyticsInterval = "[parameters('trafficAnalyticsInterval')]"
#           workspaceId              = "[parameters('workspaceId')]"
#           workspaceRegion          = "[parameters('workspaceRegion')]"
#           workspaceResourceId      = "[parameters('workspaceResourceId')]"
#         }
#       }
#       format = {
#         type    = "JSON"
#         version = "[parameters('version')]"
#       }
#       retentionPolicy = {
#         days    = "[parameters('retentionPolicyDays')]"
#         enabled = "[parameters('retentionPolicyEnabled')]"
#       }
#       storageId        = "[parameters('storageId')]"
#       targetResourceId = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-vm-monitoring-070/providers/Microsoft.Network/virtualNetworks/vnet-spoke-vm"
#     }
#   }
# }
