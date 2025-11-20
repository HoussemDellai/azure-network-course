resource "azurerm_public_ip" "pip-vm-inbound" {
  name                = "pip-vm-inbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip-vm-outbound" {
  name                = "pip-vm-outbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static" # "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-inbound" {
  name                = "nic-vm-inbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "inbound"
    subnet_id                     = azurerm_subnet.snet-vm-inbound.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-inbound.id
    primary                       = true
  }
}

resource "azurerm_network_interface" "nic-vm-outbound" {
  name                = "nic-vm-outbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "outbound"
    subnet_id                     = azurerm_subnet.snet-vm-outbound.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-outbound.id
    primary                       = true
  }
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
  name                  = "vm-win11"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4ads_v6" # "Standard_D96ads_v5" # 
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids = [azurerm_network_interface.nic-vm-inbound.id, azurerm_network_interface.nic-vm-outbound.id]
  license_type          = "Windows_Client" # Possible values are None, Windows_Client and Windows_Server.
  disk_controller_type  = "NVMe"           # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  os_disk {
    name                 = "os-disk-vm-windows"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
    disk_size_gb         = 128               # 128

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

# resource "azurerm_managed_disk" "example" {
#   name                 = "acctestmd"
#   location             = azurerm_resource_group.example.location
#   resource_group_name  = azurerm_resource_group.example.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1"
# }

output "vm_pip_inbound" {
  value = azurerm_public_ip.pip-vm-inbound.ip_address
}

output "vm_pip_outbound" {
  value = azurerm_public_ip.pip-vm-outbound.ip_address
}

output "vm_private_ip_inbound" {
  value = azurerm_network_interface.nic-vm-inbound.private_ip_address
}

output "vm_private_ip_outbound" {
  value = azurerm_network_interface.nic-vm-outbound.private_ip_address
}