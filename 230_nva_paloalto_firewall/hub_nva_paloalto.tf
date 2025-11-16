resource "azurerm_public_ip" "pip-vm-nva" {
  name                = "pip-vm-nva"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
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

# resource "azurerm_network_interface" "nic-vm-nva-paloalto" {
#   name                  = "nic-vm-nva-paloalto"
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   ip_forwarding_enabled = false

#   ip_configuration {
#     name                          = "primary-ip"
#     primary                       = true
#     subnet_id                     = azurerm_subnet.snet-nva-paloalto.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip-vm-nva.id
#   }
# }

resource "azurerm_linux_virtual_machine" "vm-nva-paloalto" {
  name                            = "vm-nva-paloalto-vmseries"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  size                            = "Standard_D2ads_v5" # "Standard_D2ads_v6" # "Standard_D3_v2"
  priority                        = "Spot"
  eviction_policy                 = "Delete"
  network_interface_ids           = [azurerm_network_interface.nic-vm-nva-untrusted.id, azurerm_network_interface.nic-vm-nva-trusted.id]
  # disk_controller_type            = "NVMe" # "SCSI" # "IDE" # "SCSI" is the default value. "NVMe" is only supported for Ephemeral OS Disk.

  custom_data = "cGx1Z2luLW9wLWNvbW1hbmRzPWFkdmFuY2Utcm91dGluZzplbmFibGU7dHlwZT1kaGNwLWNsaWVudA==" # "plugin-op-commands=advance-routing:enable;type=dhcp-client"

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching                   = "ReadOnly" # "ReadWrite"
    disk_size_gb              = 64
    name                      = "paloalto-firewall-osdisk"
    storage_account_type      = "StandardSSD_LRS"
    write_accelerator_enabled = false
  }

  plan {
    name      = "byol"
    product   = "vmseries-flex"
    publisher = "paloaltonetworks"
  }

  source_image_reference {
    offer     = "vmseries-flex"
    publisher = "paloaltonetworks"
    sku       = "byol"
    version   = "11.2.5" # "latest" # "11.1.607" # 
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