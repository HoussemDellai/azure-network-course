resource "azurerm_public_ip" "pip_in_vm" {
  name                = "pip-in-vm-win"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_vm" {
  name                = "nic-vm-win"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.snet_vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_in_vm.id
    primary                       = true
  }
}

resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                  = "vm-win11-25h2"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D8ads_v6" # "Standard_D8ads_v6"
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Delete"                              # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids = [azurerm_network_interface.nic_vm.id] # [azurerm_network_interface.nic-vm-inbound.id, azurerm_network_interface.nic-vm-outbound.id]
  license_type          = "Windows_Client"                      # Possible values are None, Windows_Client and Windows_Server.
  disk_controller_type  = "NVMe"                                # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  # custom_data = filebase64("./install-tools-windows.ps1")

  os_disk {
    name                 = "os-disk-vm-windows"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
    disk_size_gb         = 256               # 128

    diff_disk_settings {
      option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
      placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
    }
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11" # "windows11preview-arm64"
    sku       = "win11-25h2-pro"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [identity]
  }
}

resource "azurerm_managed_disk" "disk_data" {
  name                 = "disk-data"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"

  tags = {
    CostControl     = "Ignore"
    SecurityControl = "Ignore"
  }
}

# resource "azurerm_virtual_machine_data_disk_attachment" "disk-attachement" {
#   managed_disk_id    = azurerm_managed_disk.disk-data.id
#   virtual_machine_id = azurerm_windows_virtual_machine.vm-windows.id
#   lun                = "10"
#   caching            = "ReadWrite" # Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite.
#   create_option      = "Attach"    # The Create Option of the Data Disk, such as Empty or Attach. Defaults to Attach.
# }

output "pip_in_vm" {
  value = azurerm_public_ip.pip_in_vm.ip_address
}

output "vm_windows_private_ip" {
  value = azurerm_network_interface.nic_vm.private_ip_address
}

# output "lb_pip" {
#   value = azurerm_lb.lb-public.frontend_ip_configuration[0].private_ip_address
# }
