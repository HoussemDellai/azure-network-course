# resource "azurerm_network_interface" "nic-vm-windows" {
#   name                 = "nic-vm-windows"
#   resource_group_name  = azurerm_resource_group.rg.name
#   location             = azurerm_resource_group.rg.location
#   enable_ip_forwarding = false

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet-app.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip-vm.id
#   }
# }

# resource "azurerm_windows_virtual_machine" "vm" {
#   name                  = var.vm_name
#   resource_group_name   = var.resource_group_name
#   location              = var.location
#   size                  = var.vm_size
#   admin_username        = var.admin_username
#   admin_password        = var.admin_password
#   network_interface_ids = [azurerm_network_interface.nic_vm.id]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "windows-11"
#     sku       = "win11-22h2-pro"
#     version   = "latest"
#   }

#   boot_diagnostics {
#     storage_account_uri = null
#   }
# }