# resource "azurerm_public_ip" "pip-vm-nva-ubuntu" {
#   name                = "pip-vm-nva-ubuntu"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_network_interface" "nic-vm-nva-untrusted-ubuntu" {
#   name                  = "nic-vm-nva-untrusted-ubuntu"
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   ip_forwarding_enabled = true

#   ip_configuration {
#     name                          = "untrusted"
#     subnet_id                     = azurerm_subnet.snet-untrusted-ubuntu.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip-vm-nva-ubuntu.id
#   }
# }

# resource "azurerm_network_interface" "nic-vm-nva-trusted-ubuntu" {
#   name                  = "nic-vm-nva-trusted-ubuntu"
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   ip_forwarding_enabled = true

#   ip_configuration {
#     name                          = "trusted"
#     subnet_id                     = azurerm_subnet.snet-trusted-ubuntu.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm-nva-ubuntu" {
#   name                            = "opnsense-ubuntu"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   size                            = "Standard_D4ads_v6" # "Standard_B2s" # "Standard_D96ads_v5" #
#   disable_password_authentication = false
#   admin_username                  = "azureuser"
#   admin_password                  = "@Aa123456789"
#   priority                        = "Spot"
#   eviction_policy                 = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
#   network_interface_ids           = [azurerm_network_interface.nic-vm-nva-untrusted-ubuntu.id, azurerm_network_interface.nic-vm-nva-trusted-ubuntu.id]
#   disk_controller_type            = "NVMe" # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

#   os_disk {
#     name                 = "os-disk-vm-nva-ubuntu"
#     caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
#     storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
#     disk_size_gb         = 128

#     diff_disk_settings {
#       option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
#       placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
#     }
#   }

#   source_image_reference {
#     publisher = "canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   boot_diagnostics {
#     storage_account_uri = null
#   }

#   lifecycle {
#     ignore_changes = [identity]
#   }
# }

# resource "azurerm_virtual_machine_extension" "cslinux-install-opnsense-ubuntu" {
#   name                 = "cslinux"
#   virtual_machine_id   = azurerm_linux_virtual_machine.vm-nva-ubuntu.id
#   publisher            = "Microsoft.OSTCExtensions"
#   type                 = "CustomScriptForLinux"
#   type_handler_version = "1.5"
#   settings             = <<SETTINGS
#     {
#       "fileUris": [
#         "https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/205_nva_opnsense/scripts/configureopnsense.sh"
#       ],
#       "commandToExecute": "sh configureopnsense.sh 'https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/205_nva_opnsense/scripts/' '${local.opnsense_version-ubuntu}' '${local.trusted_gw_ip-ubuntu}' '${local.opnsense_pip-ubuntu}'"
#     }
#     SETTINGS
# }

# locals {
#   trusted_ipv4_prefixes-ubuntu = [for p in azurerm_subnet.snet-trusted-ubuntu.address_prefixes : p if !can(regex(":", p))]
#   trusted_gw_ip-ubuntu         = cidrhost(local.trusted_ipv4_prefixes-ubuntu[0], 1)
#   opnsense_version-ubuntu      = "25.7"
#   opnsense_pip-ubuntu          = azurerm_public_ip.pip-vm-nva-ubuntu.ip_address
# }

# resource "azurerm_subnet" "snet-untrusted-ubuntu" {
#   name                            = "snet-untrusted-ubuntu"
#   resource_group_name             = azurerm_virtual_network.vnet-hub.resource_group_name
#   virtual_network_name            = azurerm_virtual_network.vnet-hub.name
#   address_prefixes                = ["10.0.10.0/24"]
#   default_outbound_access_enabled = true
# }

# resource "azurerm_subnet" "snet-trusted-ubuntu" {
#   name                            = "snet-trusted-ubuntu"
#   resource_group_name             = azurerm_virtual_network.vnet-hub.resource_group_name
#   virtual_network_name            = azurerm_virtual_network.vnet-hub.name
#   address_prefixes                = ["10.0.11.0/24"]
#   default_outbound_access_enabled = true
# }
