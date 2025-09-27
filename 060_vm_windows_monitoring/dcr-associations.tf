resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dce" {
  target_resource_id          = azurerm_linux_virtual_machine.vm_linux.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  description                 = "DCR association for vm linux and DCE"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dcr" {
  name                    = "dcr-association-vm-linux-dcr"
  target_resource_id      = azurerm_linux_virtual_machine.vm_linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_linux.id
  description             = "DCR association for vm linux and DCR"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_windows_dce" {
  target_resource_id          = azurerm_windows_virtual_machine.vm_windows.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  description                 = "DCR association for vm windows and DCE"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_windows_dcr" {
  name                    = "dcr-association-vm-windows-dcr"
  target_resource_id      = azurerm_windows_virtual_machine.vm_windows.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_windows.id
  description             = "DCR association for vm windows and DCR"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dcr_vm_insights" {
  name                    = "dcr-association-vm-linux-dcr-vm-insights"
  target_resource_id      = azurerm_linux_virtual_machine.vm_linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_vm_insights.id
  description             = "DCR association for vm linux and DCR vm insights"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_windows_dcr_vm_insights" {
  name                    = "dcr-association-vm-windows-dcr-vm-insights"
  target_resource_id      = azurerm_windows_virtual_machine.vm_windows.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_vm_insights.id
  description             = "DCR association for vm windows and DCR vm insights"
}