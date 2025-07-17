resource "azurerm_virtual_network" "vnet-spoke03" {
  name                = "vnet-spoke03"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.21.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke03-vm" {
  name                 = "snet-spoke03-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke03.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke03.name
  address_prefixes     = ["10.21.0.0/24"]
}

module "vm_linux_spoke_03" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke3"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region2
  subnet_id           = azurerm_subnet.snet-spoke03-vm.id
  install_webapp      = true
}

resource "azurerm_virtual_hub_connection" "connection-vhub-vnet03" {
  name                      = "connection-vhub-vnet03"
  virtual_hub_id            = azurerm_virtual_hub.vhub02.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke03.id
  internet_security_enabled = false
}
