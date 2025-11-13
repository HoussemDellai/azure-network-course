resource "azurerm_public_ip" "pip-vm-nva" {
  name                = "pip-vm-nva"
  resource_group_name = azurerm_resource_group.rg-paloalto.name
  location            = azurerm_resource_group.rg-paloalto.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # zones               = [1]
}

resource "azurerm_network_interface" "nic-vm-nva-paloalto" {
  name                  = "nic-vm-nva-paloalto"
  resource_group_name   = azurerm_resource_group.rg-paloalto.name
  location              = azurerm_resource_group.rg-paloalto.location
  ip_forwarding_enabled = false

  ip_configuration {
    name                          = "primary-ip"
    primary                       = true
    subnet_id                     = azurerm_subnet.snet-nva-paloalto.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-nva.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-nva-paloalto" {
  name                            = "paloalto-vmseries-firewall"
  resource_group_name             = azurerm_resource_group.rg-paloalto.name
  location                        = azurerm_resource_group.rg-paloalto.location
  disable_password_authentication = false
  admin_username                  = "panadmin"
  admin_password                  = "@Aa123456789"
  size                            = "Standard_D3_v2"
  network_interface_ids           = [azurerm_network_interface.nic-vm-nva-paloalto.id]

  custom_data                     = "cGx1Z2luLW9wLWNvbW1hbmRzPWFkdmFuY2Utcm91dGluZzplbmFibGU7dHlwZT1kaGNwLWNsaWVudA==" # "plugin-op-commands=advance-routing:enable;type=dhcp-client"

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 60
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
    version   = "11.1.607"
  }
}

output "vm_nva_public_ip" {
  value = azurerm_public_ip.pip-vm-nva.ip_address
}

output "vm_nva_private_ip" {
  value = azurerm_network_interface.nic-vm-nva-paloalto.private_ip_address
}