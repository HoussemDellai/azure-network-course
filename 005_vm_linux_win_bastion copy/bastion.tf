module "bastion" {
  source              = "../modules/bastion"
  resource_group_name = "rg-bastion"
  location            = azurerm_resource_group.rg-hub.location
  subnet_id           = azurerm_subnet.subnet-bastion.id
}
