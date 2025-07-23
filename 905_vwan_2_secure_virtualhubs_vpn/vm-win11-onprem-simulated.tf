resource "azurerm_virtual_network" "vnet-onprem" {
  name                = "vnet-onprem"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-onprem-vm" {
  name                 = "snet-onprem-vm"
  resource_group_name  = azurerm_virtual_network.vnet-onprem.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-onprem.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-onprem-vm" {
  name                = "nsg-onprem-vm"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet-onprem-vm-nsg" {
  subnet_id                 = azurerm_subnet.snet-onprem-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-onprem-vm.id
}

module "vm_windows_onprem" {
  source              = "../modules/vm_windows"
  vm_name             = "vm-win11-onprem"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region1
  subnet_id           = azurerm_subnet.snet-onprem-vm.id
  install_webapp      = true
  enable_public_ip    = true
}

output "vm_windows_onprem_pip" {
  value = module.vm_windows_onprem.public_ip
}