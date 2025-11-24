resource "azurerm_public_ip" "pip-vm-nva" {
  name                = "pip-vm-nva"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # domain_name_label   = "opnsense"
  # zones               = [1]
}

resource "azurerm_network_interface" "nic-vm-nva-untrusted" {
  name                  = "nic-vm-nva-untrusted"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "untrusted"
    subnet_id                     = azurerm_subnet.snet-untrusted.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-nva.id
  }
}

resource "azurerm_network_interface" "nic-vm-nva-trusted" {
  name                  = "nic-vm-nva-trusted"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "trusted"
    subnet_id                     = azurerm_subnet.snet-trusted.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-nva" {
  name                            = "vm-nva-opnsense"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D4ads_v6" # "Standard_B2s" # "Standard_D96ads_v5" #
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic-vm-nva-untrusted.id, azurerm_network_interface.nic-vm-nva-trusted.id]
  disk_controller_type            = "NVMe" # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.
  zone                            = 1
  # priority                        = "Spot"
  # eviction_policy                 = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.

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

  tags = {
    CostControl     = "Ignore"
    SecurityControl = "Ignore"
  }
}

output "vm_nva_public_ip" {
  value = azurerm_public_ip.pip-vm-nva.ip_address
}

output "vm_nva_private_ip_trusted" {
  value = azurerm_network_interface.nic-vm-nva-trusted.private_ip_address
}

output "vm_nva_private_ip_untrusted" {
  value = azurerm_network_interface.nic-vm-nva-untrusted.private_ip_address
}
