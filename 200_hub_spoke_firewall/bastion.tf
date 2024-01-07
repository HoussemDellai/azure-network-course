module "bastion" {
  source              = "../modules/bastion"
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  subnet_id           = azurerm_subnet.subnet-bastion.id
}