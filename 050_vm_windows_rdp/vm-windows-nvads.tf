resource "azurerm_public_ip" "pip-vm-windows-nvads" {
  name                = "pip-vm-windows-nvads"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-windows-nvads" {
  name                = "nic-vm-windows-nvads"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-windows-nvads.id
  }
}

resource "azurerm_windows_virtual_machine" "vm-windows-nvads" {
  name                  = "vm-win11-nvads"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_NV12ads_A10_v5" # "Standard_D4ads_v6" # "Standard_D96ads_v5" # 
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids = [azurerm_network_interface.nic-vm-windows-nvads.id]
  license_type          = "Windows_Client" # Possible values are None, Windows_Client and Windows_Server.
  # disk_controller_type  = "NVMe"           # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  custom_data = filebase64("../scripts/install-tools-windows.ps1")
  # custom_data = filebase64("./run-winget-configuration.ps1")
  # custom_data = filebase64("../scripts/install-tools-windows-vm-winget-mini.ps1")

  os_disk {
    name                 = "os-disk-vm-windows-nvads"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS" # 
    disk_size_gb         = 128

    # diff_disk_settings {
    #   option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
    #   placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
    # }
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11" # "windows11preview-arm64"
    sku       = "win11-24h2-pro"
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

resource "azurerm_virtual_machine_extension" "cse-nvads" {
  name                 = "cse"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-windows-nvads.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1 > c:/azuredata/install.ps1.log\""
    }
    SETTINGS

  timeouts {
    create = "60m"
    read   = "5m"
    update = "30m"
    delete = "30m"
  }
}

resource "azurerm_role_assignment" "owner-nvads" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_windows_virtual_machine.vm-windows-nvads.identity[0].principal_id
}

# data "azurerm_subscription" "current" {}

output "vm_windows_nvads_public_ip" {
  value = azurerm_public_ip.pip-vm-windows-nvads.ip_address
}

output "vm_windows_nvads_private_ip" {
  value = azurerm_network_interface.nic-vm-windows-nvads.private_ip_address
}
