resource "azurerm_public_ip" "pip-vm-windows" {
  name                = "pip-vm-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-windows" {
  name                = "nic-vm-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-nva.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-windows.id
  }
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
  name                  = "vm-win11-nva"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4ads_v6" # "Standard_D96ads_v5" # 
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids = [azurerm_network_interface.nic-vm-windows.id]
  license_type          = "Windows_Client" # Possible values are None, Windows_Client and Windows_Server.
  disk_controller_type  = "NVMe"           # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  custom_data = filebase64("../scripts/install-tools-windows.ps1")
  # custom_data = filebase64("./run-winget-configuration.ps1")
  # custom_data = filebase64("../scripts/install-tools-windows-vm-winget-mini.ps1")

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
    offer     = "windows-11" # "windows11preview-arm64"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity-ama.id]
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [identity]
  }
}

resource "azurerm_virtual_machine_extension" "cse" {
  name                 = "cse"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-windows.id
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

# managed identity for Azure Monitor Agent
resource "azurerm_user_assigned_identity" "identity-ama" {
  name                = "identity-ama"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# role assignment for the managed identity
resource "azurerm_role_assignment" "ama-mi" {
  scope                = azurerm_windows_virtual_machine.vm-windows.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.identity-ama.principal_id
}

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "ama"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm-windows.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  settings                   = <<SETTINGS
    {
      "authentication": {
        "managedIdentity": {
          "identifier-name": "mi_res_id",
          "identifier-value": "${azurerm_user_assigned_identity.identity-ama.id}"
        }
      }
    }
  SETTINGS
}

resource "azurerm_role_assignment" "owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_windows_virtual_machine.vm-windows.identity[0].principal_id
}

data "azurerm_subscription" "current" {}

output "vm_windows_public_ip" {
  value = azurerm_public_ip.pip-vm-windows.ip_address
}

output "vm_windows_private_ip" {
  value = azurerm_network_interface.nic-vm-windows.private_ip_address
}
