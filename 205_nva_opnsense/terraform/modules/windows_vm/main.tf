# Windows VM Module

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
}

variable "admin_username" {
  description = "Admin username"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

# Public IP for Windows VM
resource "azurerm_public_ip" "windows" {
  name                = "${var.vm_name}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "OPNsense"
  }
}

# Network Security Group for Windows VM
resource "azurerm_network_security_group" "windows" {
  name                = "${var.vm_name}-NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Network Interface for Windows VM
resource "azurerm_network_interface" "windows" {
  name                = "${var.vm_name}-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate NSG with Windows NIC
resource "azurerm_network_interface_security_group_association" "windows" {
  network_interface_id      = azurerm_network_interface.windows.id
  network_security_group_id = azurerm_network_security_group.windows.id
}

# Route Table for Windows VM
resource "azurerm_route_table" "windows" {
  name                = "winvmroutetable"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = "OPNsense"
  }
}

# Associate route table with subnet
resource "azurerm_subnet_route_table_association" "windows" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.windows.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "windows" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.windows.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Outputs
output "private_ip_address" {
  value = azurerm_network_interface.windows.private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.windows.ip_address
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.windows.id
}
