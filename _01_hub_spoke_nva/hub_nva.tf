module "vm-hub-nva" {
  source               = "../modules/vm_linux"
  vm_name              = "vm-hub-nva"
  resource_group_name  = "rg-hub-nva"
  location             = azurerm_resource_group.rg-hub.location
  subnet_id            = azurerm_subnet.subnet-nva.id
  enable_public_ip     = false
  enable_ip_forwarding = true
  tags                 = var.tags
}

resource "azurerm_virtual_machine_extension" "install-networking-tools" {
  count                = 1
  name                 = "install-networking-tools"
  virtual_machine_id   = module.vm-hub-nva.virtual_machine_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/HoussemDellai/azure-network-hub-spoke/main/scripts/install-networking-tools.sh"
        ],
        "commandToExecute": "sh install-networking-tools.sh"
    }
SETTINGS
}