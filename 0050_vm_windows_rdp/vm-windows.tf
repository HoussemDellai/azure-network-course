resource "azurerm_public_ip" "pip-vm-windows" {
  name                = "pip-vm-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-vm-windows" {
  name                = "nic-vm-windows"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm-windows.id
  }
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
  name                  = "vm-win11"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4ds_v5"
  admin_username        = "azureuser"
  admin_password        = "@Aa123456789"
  priority              = "Spot"
  eviction_policy       = "Deallocate"
  network_interface_ids = [azurerm_network_interface.nic-vm-windows.id]

  custom_data = filebase64("./install-tools-windows.ps1")

  os_disk {
    name                 = "os-disk-vm-windows"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11" # "windows11preview-arm64"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [identity]
  }
}

resource "azurerm_virtual_machine_extension" "cse" {
  name                 = "cse"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1\""
    }
    SETTINGS
}
