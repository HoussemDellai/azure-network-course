resource "azurerm_public_ip" "pip-bastion" {
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                   = "bastion"
  resource_group_name    = azurerm_resource_group.rg-hub.name
  location               = azurerm_resource_group.rg-hub.location
  sku                    = "Standard" # "Standard" # "Basic", "Developer"
  copy_paste_enabled     = true
  file_copy_enabled      = false
  shareable_link_enabled = false
  tunneling_enabled      = false
  ip_connect_enabled     = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-hub-bastion.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }

  lifecycle {
    ignore_changes = all
  }
}