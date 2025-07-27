resource "azurerm_public_ip" "pip-vm-nva" {
  name                = "pip-vm-nva"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-nva-untrusted" {
  name                = "nic-vm-nva-untrusted"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "untrusted"
    subnet_id                     = azurerm_subnet.snet-untrusted.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-nva.id
  }
}

resource "azurerm_network_interface" "nic-vm-nva-trusted" {
  name                = "nic-vm-nva-trusted"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "trusted"
    subnet_id                     = azurerm_subnet.snet-trusted.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-nva" {
  name                            = "vm-nva"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D4ads_v6" # "Standard_D96ads_v5" # 
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  priority                        = "Spot"
  eviction_policy                 = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids           = [azurerm_network_interface.nic-vm-nva-untrusted.id, azurerm_network_interface.nic-vm-nva-trusted.id]
  disk_controller_type            = "NVMe" # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  # custom_data = filebase64("../scripts/install-tools-windows.ps1")
  # custom_data = filebase64("./run-winget-configuration.ps1")
  # custom_data = filebase64("../scripts/install-tools-windows-vm-winget-mini.ps1")

  os_disk {
    name                 = "os-disk-vm-nva"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
    disk_size_gb         = 128

    diff_disk_settings {
      option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
      placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
    }
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_1" # "windows11preview-arm64"
    sku       = "14_1-release-amd64-gen2-zfs"
    version   = "latest"
  }

  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    publisher = "thefreebsdfoundation"
    product   = "freebsd-14_1"
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

resource "azurerm_virtual_machine_extension" "cslinux" {
  name                 = "cslinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-nva.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  settings             = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/dmauser/opnazure/master/scripts/configureopnsense.sh"
      ],
      "commandToExecute": "sh configureopnsense.sh 'https://raw.githubusercontent.com/dmauser/opnazure/master/scripts/' '25.7' '2.12.0.4' 'TwoNics' '10.0.1.0/24' '' '' ''"
    }
    SETTINGS

  timeouts {
    create = "60m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  }
}

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

# resource "azurerm_role_assignment" "owner" {
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = "Owner"
#   principal_id         = azurerm_windows_virtual_machine.vm-windows.identity[0].principal_id
# }

# data "azurerm_subscription" "current" {}

