module "vm-hub-nva" {
  source                = "../modules/vm_linux"
  vm_name               = "vm-hub-nva"
  resource_group_name   = azurerm_resource_group.rg-hub.name
  location              = azurerm_resource_group.rg-hub.location
  subnet_id             = azurerm_subnet.subnet-nva.id
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  ip_forwarding_enabled = true
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
