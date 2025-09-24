resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dce" {
  target_resource_id          = azurerm_linux_virtual_machine.vm-linux.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  description                 = "DCR association for vm linux and DCE"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_linux_dcr" {
  name                    = "dcr-association-vm-linux-dcr"
  target_resource_id      = azurerm_linux_virtual_machine.vm-linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr-linux.id
  description             = "DCR association for vm linux and DCR"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_windows_dce" {
  target_resource_id          = azurerm_windows_virtual_machine.vm-windows.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  description                 = "DCR association for vm windows and DCE"
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association_vm_windows_dcr" {
  name                    = "dcr-association-vm-windows-dcr"
  target_resource_id      = azurerm_windows_virtual_machine.vm-windows.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr-windows.id
  description             = "DCR association for vm windows and DCR"
}