module "vm-hub-app" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-hub-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-hub-app.id
  install_webapp      = true
  enable_public_ip    = false
}

output "vm_hub_app_private_ip" {
  value = module.vm-hub-app.vm_private_ip
}