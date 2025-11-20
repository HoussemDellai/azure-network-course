resource "azurerm_resource_group" "rg-vpnclient" {
  name     = "rg-vpnclient-${var.prefix}"
  location = "swedencentral"
}

resource "azurerm_virtual_network" "vnet-vpnclient" {
  name                = "vnet-vpnclient"
  resource_group_name = azurerm_resource_group.rg-vpnclient.name
  location            = azurerm_resource_group.rg-vpnclient.location
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "snet-vpnclient" {
  name                            = "snet-vpnclient"
  resource_group_name             = azurerm_virtual_network.vnet-vpnclient.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet-vpnclient.name
  address_prefixes                = ["192.168.0.0/24"]
  default_outbound_access_enabled = true
}

resource "azurerm_network_security_group" "nsg-vm-vpnclient" {
  name                = "nsg-vm-vpnclient"
  location            = azurerm_resource_group.rg-vpnclient.location
  resource_group_name = azurerm_resource_group.rg-vpnclient.name
}

resource "azurerm_network_security_rule" "allow-all-tcp" {
  network_security_group_name  = azurerm_network_security_group.nsg-vm-vpnclient.name
  resource_group_name          = azurerm_network_security_group.nsg-vm-vpnclient.resource_group_name
  name                         = "allow-all-tcp"
  access                       = "Allow"
  priority                     = 100
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "*"
  source_port_range            = "*"
  destination_address_prefix   = "*"
  destination_port_range       = "*"
}

resource "azurerm_network_security_rule" "allow-all-udp" {
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
  resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
  name                        = "allow-all-udp"
  access                      = "Allow"
  priority                    = 101
  direction                   = "Inbound"
  protocol                    = "Udp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.snet-vpnclient.id
  network_security_group_id = azurerm_network_security_group.nsg-vm-vpnclient.id
}

resource "azurerm_public_ip" "pip-vm-windows-vpnclient" {
  name                = "pip-vm-windows-vpnclient"
  resource_group_name = azurerm_resource_group.rg-vpnclient.name
  location            = azurerm_resource_group.rg-vpnclient.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-windows-vpnclient" {
  name                = "nic-vm-windows-vpnclient"
  resource_group_name = azurerm_resource_group.rg-vpnclient.name
  location            = azurerm_resource_group.rg-vpnclient.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-vpnclient.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-windows-vpnclient.id
  }
}

resource "azurerm_windows_virtual_machine" "vm-windows-vpnclient" {
  name                  = "vm-win11"
  resource_group_name   = azurerm_resource_group.rg-vpnclient.name
  location              = azurerm_resource_group.rg-vpnclient.location
  size                  = "Standard_D4ads_v6" # "Standard_D96ads_v5" # 
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Delete" # "Deallocate" # With Spot, there's no option of Stop-Deallocate for Ephemeral VMs, rather users need to Delete instead of deallocating them.
  network_interface_ids = [azurerm_network_interface.nic-vm-windows-vpnclient.id]
  license_type          = "Windows_Client" # Possible values are None, Windows_Client and Windows_Server.
  disk_controller_type  = "NVMe"           # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  os_disk {
    name                 = "os-disk-vm-windows-vpnclient"
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

output "vm_windows_vpnclient_public_ip" {
  value = azurerm_public_ip.pip-vm-windows-vpnclient.ip_address
}

output "vm_windows_vpnclient_private_ip" {
  value = azurerm_network_interface.nic-vm-windows-vpnclient.private_ip_address
}
