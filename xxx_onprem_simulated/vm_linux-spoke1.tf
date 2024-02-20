resource "azurerm_network_interface" "nic-vm-spoke1" {
  name                 = "nic-vm-spoke1"
  resource_group_name  = azurerm_resource_group.rg-spoke1.name
  location             = azurerm_resource_group.rg-spoke1.location
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-spoke1-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "vm-spoke1" {
  name                            = "vm-linux-spoke1"
  resource_group_name             = azurerm_resource_group.rg-spoke1.name
  location                        = azurerm_resource_group.rg-spoke1.location
  size                            = "Standard_B2ats_v2"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic-vm-spoke1.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"

  custom_data = filebase64("./install-webapp.sh")

  os_disk {
    name                 = "os-disk-vm-spoke1"
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
