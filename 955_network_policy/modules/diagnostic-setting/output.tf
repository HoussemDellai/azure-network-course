output "monitor_diagnostic_categories" {
  value = join(", ", data.azurerm_monitor_diagnostic_categories.categories.log_category_types, data.azurerm_monitor_diagnostic_categories.categories.metrics)
}