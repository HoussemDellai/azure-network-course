resource "azurerm_network_interface" "nic-vm-hub-nva" {
  name                = "nic-vm-hub-nva"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location

  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-hub-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "vm-hub-nva" {
  name                            = "vm-linux-hub-nva"
  resource_group_name             = azurerm_resource_group.rg-hub.name
  location                        = azurerm_resource_group.rg-hub.location
  size                            = "Standard_B2ats_v2"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic-vm-hub-nva.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"

  custom_data = filebase64("./enable-ip-forwarding.sh")

  os_disk {
    name                 = "os-disk-vm-nva-hub"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}