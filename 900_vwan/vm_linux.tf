module "vm_linux_snet-vnet-hub-01-spoke-01" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-${azurerm_subnet.snet-vnet-hub-01-spoke-01-vm.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-vnet-hub-01-spoke-01-vm.id
  install_webapp      = true
}

module "vm_linux_snet-vnet-hub-01-spoke-02" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-${azurerm_subnet.snet-vnet-hub-01-spoke-02-vm.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-vnet-hub-01-spoke-02-vm.id
  install_webapp      = true
}

module "vm_linux_snet-vnet-hub-02-spoke-01" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-${azurerm_subnet.snet-vnet-hub-02-spoke-01-vm.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-vnet-hub-02-spoke-01-vm.id
  install_webapp      = true
}

# resource "azurerm_network_interface" "nic-vm-linux" {
#   name                  = "nic-vm-linux"
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   ip_forwarding_enabled = false

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.snet-vnet-hub-01-spoke-01-vm.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = null
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm-linux" {
#   name                            = "vm-linux"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   size                            = "Standard_B2ats_v2"
#   disable_password_authentication = false
#   admin_username                  = "azureuser"
#   admin_password                  = "@Aa123456789"
#   network_interface_ids           = [azurerm_network_interface.nic-vm-linux.id]
#   priority                        = "Spot"
#   eviction_policy                 = "Deallocate"

#   custom_data = filebase64("./install-webapp.sh")

#   os_disk {
#     name                 = "os-disk-vm-linux"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   boot_diagnostics {
#     storage_account_uri = null
#   }
# }
