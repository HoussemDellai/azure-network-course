resource "azurerm_public_ip" "pip_vm" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "pip-${var.vm_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_vm" {
  name                  = "nic-${var.vm_name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_forwarding_enabled = var.ip_forwarding_enabled
  tags                  = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.pip_vm.0.id : null
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  disable_password_authentication = false
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.nic_vm.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"
  tags                            = var.tags

  custom_data = var.install_webapp ? filebase64("../scripts/install-webapp.sh") : null

  os_disk {
    name                 = "os-disk-${var.vm_name}"
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
