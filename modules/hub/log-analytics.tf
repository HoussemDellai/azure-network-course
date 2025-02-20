resource "azurerm_log_analytics_workspace" "log-analytics" {
  name                            = "log-analytics"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  sku                             = "PerGB2018"
  retention_in_days               = 30
  allow_resource_only_permissions = false
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
}
