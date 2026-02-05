# resource "azurerm_virtual_machine_run_command" "run_command_install_tools_windows" {
#   name               = "run-command-install-tools-windows11"
#   location           = azurerm_windows_virtual_machine.vm_windows.location
#   virtual_machine_id = azurerm_windows_virtual_machine.vm_windows.id

#   run_as_user     = "azureuser"
#   run_as_password = "@Aa123456789"

#   source {
#     script = file("./install-tools-windows.ps1")
#   }
# }

# # wait for reboot to complete before running next command, about 20 seconds
# resource "time_sleep" "wait_20_seconds" {
#   create_duration = "20s"

#   depends_on = [azurerm_virtual_machine_run_command.run_command_install_tools_windows]
# }

# resource "azurerm_virtual_machine_run_command" "run_command_install_comfyui" {
#   name               = "run-command-install-comfyui"
#   location           = azurerm_linux_virtual_machine.vm_linux.location
#   virtual_machine_id = azurerm_linux_virtual_machine.vm_linux.id

#   source {
#     script = file("./02-install-comfyui.sh")
#   }

#   depends_on = [time_sleep.wait_20_seconds]
# }

# resource "azurerm_virtual_machine_run_command" "run_command_download_models" {
#   name               = "run-command-download-models"
#   location           = azurerm_linux_virtual_machine.vm_linux.location
#   virtual_machine_id = azurerm_linux_virtual_machine.vm_linux.id

#   source {
#     script = file("./03-download-models.sh")
#   }

#   depends_on = [azurerm_virtual_machine_run_command.run_command_install_comfyui]
# }
