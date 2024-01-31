module "vm-hub-nva" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-hub-nva"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet-vm.id

  enable_ip_forwarding = true
  install_webapp       = false
  enable_public_ip     = true
}

resource "azurerm_virtual_machine_extension" "install-networking-tools" {
  count                = 0
  name                 = "install-networking-tools"
  virtual_machine_id   = module.vm-hub-nva.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/HoussemDellai/azure-network-hub-spoke/main/scripts/configure-networking.sh"
        ],
        "commandToExecute": "./configure-networking.sh"
    }
SETTINGS
}
