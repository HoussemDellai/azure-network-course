resource "azurerm_virtual_network" "vnet-spoke02" {
  name                = "vnet-spoke02"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.12.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke02-vm" {
  name                 = "snet-spoke02-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke02.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke02.name
  address_prefixes     = ["10.12.0.0/24"]
}

module "vm_linux_spoke02" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region1
  subnet_id           = azurerm_subnet.snet-spoke02-vm.id
  install_webapp      = true
}

resource "azurerm_virtual_hub_connection" "connection-vhub-vnet02" {
  name                      = "connection-vhub-vnet02"
  virtual_hub_id            = azurerm_virtual_hub.vhub01.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke02.id
  internet_security_enabled = false
}
