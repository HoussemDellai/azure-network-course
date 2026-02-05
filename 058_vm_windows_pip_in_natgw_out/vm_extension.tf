# resource "azurerm_virtual_machine_extension" "cse" {
#   name                 = "cse"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm-windows.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"
#   settings             = <<SETTINGS
#     {
#         "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1 > c:/azuredata/install.ps1.log\""
#     }
#     SETTINGS

#   timeouts {
#     create = "60m"
#     read   = "5m"
#     update = "30m"
#     delete = "30m"
#   }
# }