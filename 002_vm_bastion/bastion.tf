module "bastion" {
  source              = "../modules/bastion"
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet-bastion.id
}
