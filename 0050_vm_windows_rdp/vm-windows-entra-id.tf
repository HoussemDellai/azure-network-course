
# resource "azurerm_virtual_machine_extension" "entra-id-login" {
#   name                       = "entra-id-login"
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm-windows.id
#   publisher                  = "Microsoft.Azure.ActiveDirectory"
#   type                       = "AADLoginForWindows"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = true
# }

# resource "azurerm_role_assignment" "virtual-machine-administrator-login" {
#   scope                = azurerm_windows_virtual_machine.vm-windows.id
#   role_definition_name = "Virtual Machine Administrator Login"
#   principal_id         = data.azurerm_client_config.current.object_id # azurerm_windows_virtual_machine.vm-windows.identity[0].principal_id
# }

# data "azurerm_client_config" "current" {}
