resource "azurerm_public_ip" "pip-vm-openvpn" {
  name                = "pip-vm-openvpn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-openvpn" {
  name                = "nic-vm-openvpn"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-openvpn.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-openvpn" {
  name                            = "vm-linux-openvpn"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2ads_v5"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic-vm-openvpn.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"

  # custom_data = filebase64("./install-openvpn.sh")

  os_disk {
    name                 = "os-disk-vm-linux-openvpn"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
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
