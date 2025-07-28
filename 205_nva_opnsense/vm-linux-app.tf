resource "azurerm_network_interface" "nic_vm" {
  name                  = "nic-vm-linux-hub-app"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-hub-app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "vm-linux-hub-app" {
  name                            = "vm-linux-hub-app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B2s" # "Standard_D96ads_v5" #
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic_vm.id]
#   priority                        = "Spot"
#   eviction_policy                 = "Delete"
#   disk_controller_type            = "NVMe" # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  custom_data = filebase64("../scripts/install-webapp.sh")

  os_disk {
    name                 = "os-disk-linux"
    caching              = "ReadOnly"        # "ReadWrite" # None, ReadOnly and ReadWrite.
    storage_account_type = "StandardSSD_LRS" # "Standard_LRS"
    disk_size_gb         = 64

    # diff_disk_settings {
    #   option    = "Local"    # Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local.
    #   placement = "NvmeDisk" # "ResourceDisk" # "CacheDisk" # Specifies the Ephemeral Disk Placement for the OS Disk. NvmeDisk can only be used for v6 VMs
    # }
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-25_04" # "0001-com-ubuntu-server-jammy"
    sku       = "minimal"      # "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

output "vm_hub_app_private_ip" {
  value = azurerm_network_interface.nic_vm.private_ip_address
}
