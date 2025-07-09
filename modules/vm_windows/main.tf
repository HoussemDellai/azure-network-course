resource "azurerm_public_ip" "pip_vm" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "pip-${var.vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_vm" {
  name                  = "nic-${var.vm_name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_forwarding_enabled = var.ip_forwarding_enabled
  tags                  = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.pip_vm.0.id : null
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_vm.id]
  priority              = "Spot"
  eviction_policy       = "Delete"
  license_type          = "Windows_Client" # Possible values are None, Windows_Client and Windows_Server.
  disk_controller_type  = "NVMe"           # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.
  tags                  = var.tags

  custom_data = var.install_webapp ? filebase64("../scripts/install-tools-windows.ps1") : null

  os_disk {
    name                 = "os-disk-vm-windows"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
    disk_size_gb         = 128

    diff_disk_settings {
      option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
      placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
    }
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [identity]
  }
}

resource "azurerm_virtual_machine_extension" "cloudinit" {
  name                 = "cloudinit"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1\""
    }
    SETTINGS
}
