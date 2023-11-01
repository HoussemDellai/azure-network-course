resource "azurerm_public_ip" "public_ip_bastion" {
  name                = "public-ip-bastion"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  name                   = "bastion-host"
  location               = azurerm_resource_group.rg-hub.location
  resource_group_name    = azurerm_resource_group.rg-hub.name
  sku                    = "Standard"
  scale_units            = 2 # between 2 and 50
  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = false
  tags                   = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.public_ip_bastion.id
  }
}