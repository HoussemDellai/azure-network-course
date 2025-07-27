# OPNsense VM Module

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

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "untrusted_subnet_id" {
  description = "Untrusted subnet ID"
  type        = string
}

variable "trusted_subnet_id" {
  description = "Trusted subnet ID"
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID (optional)"
  type        = string
  default     = ""
}

variable "nsg_id" {
  description = "Network Security Group ID"
  type        = string
}

variable "external_lb_backend_pool_id" {
  description = "External Load Balancer Backend Pool ID"
  type        = string
  default     = ""
}

variable "internal_lb_backend_pool_id" {
  description = "Internal Load Balancer Backend Pool ID"
  type        = string
  default     = ""
}

variable "external_lb_nat_rule_id" {
  description = "External Load Balancer NAT Rule ID"
  type        = string
  default     = ""
}

variable "shell_script_obj" {
  description = "Shell script configuration object"
  type = object({
    opn_script_uri                    = string
    opn_version                       = string
    wa_linux_version                  = string
    opn_type                          = string
    trusted_subnet_name               = string
    windows_subnet_name               = string
    public_ip_address                 = string
    opn_sense_secondary_trusted_nic_ip = string
  })
}

variable "shell_script_name" {
  description = "Shell script name"
  type        = string
}

variable "temp_username" {
  description = "Temporary username"
  type        = string
}

variable "temp_password" {
  description = "Temporary password"
  type        = string
  sensitive   = true
}

# Data sources for subnet information
data "azurerm_subnet" "trusted" {
  name                 = split("/", var.trusted_subnet_id)[10]
  virtual_network_name = split("/", var.trusted_subnet_id)[8]
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "windows" {
  count                = var.shell_script_obj.windows_subnet_name != "" ? 1 : 0
  name                 = split("/", var.shell_script_obj.windows_subnet_name)[1]
  virtual_network_name = split("/", var.shell_script_obj.windows_subnet_name)[0]
  resource_group_name  = var.resource_group_name
}

locals {
  untrusted_nic_name = "${var.vm_name}-Untrusted-NIC"
  trusted_nic_name   = "${var.vm_name}-Trusted-NIC"
  
  # Get subnet CIDR for trusted subnet
  trusted_subnet_cidr = length(data.azurerm_subnet.trusted.address_prefixes) > 0 ? data.azurerm_subnet.trusted.address_prefixes[0] : data.azurerm_subnet.trusted.address_prefix
  
  # Get subnet CIDR for windows subnet
  windows_subnet_cidr = var.shell_script_obj.windows_subnet_name != "" ? (
    length(data.azurerm_subnet.windows[0].address_prefixes) > 0 ? data.azurerm_subnet.windows[0].address_prefixes[0] : data.azurerm_subnet.windows[0].address_prefix
  ) : "1.1.1.1/32"
}

# Untrusted NIC
resource "azurerm_network_interface" "untrusted" {
  name                 = local.untrusted_nic_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.untrusted_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id != "" ? var.public_ip_id : null
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate NSG with untrusted NIC
resource "azurerm_network_interface_security_group_association" "untrusted" {
  network_interface_id      = azurerm_network_interface.untrusted.id
  network_security_group_id = var.nsg_id
}

# Associate with external load balancer backend pool
resource "azurerm_network_interface_backend_address_pool_association" "untrusted" {
  count                   = var.external_lb_backend_pool_id != "" ? 1 : 0
  network_interface_id    = azurerm_network_interface.untrusted.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.external_lb_backend_pool_id
}

# Associate with external load balancer NAT rule
resource "azurerm_network_interface_nat_rule_association" "untrusted" {
  count                 = var.external_lb_nat_rule_id != "" ? 1 : 0
  network_interface_id  = azurerm_network_interface.untrusted.id
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = var.external_lb_nat_rule_id
}

# Trusted NIC
resource "azurerm_network_interface" "trusted" {
  name                 = local.trusted_nic_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate NSG with trusted NIC
resource "azurerm_network_interface_security_group_association" "trusted" {
  network_interface_id      = azurerm_network_interface.trusted.id
  network_security_group_id = var.nsg_id
}

# Associate with internal load balancer backend pool
resource "azurerm_network_interface_backend_address_pool_association" "trusted" {
  count                   = var.internal_lb_backend_pool_id != "" ? 1 : 0
  network_interface_id    = azurerm_network_interface.trusted.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.internal_lb_backend_pool_id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "opnsense" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.temp_username
  admin_password      = var.temp_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.untrusted.id,
    azurerm_network_interface.trusted.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    product   = "freebsd-14_1"
    publisher = "thefreebsdfoundation"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_1"
    sku       = "14_1-release-amd64-gen2-zfs"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# VM Extension for OPNsense configuration
resource "azurerm_virtual_machine_extension" "opnsense_config" {
  name                 = "CustomScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.opnsense.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  auto_upgrade_minor_version = false

  settings = jsonencode({
    fileUris = [
      "${var.shell_script_obj.opn_script_uri}${var.shell_script_name}"
    ]
    commandToExecute = "sh ${var.shell_script_name} ${var.shell_script_obj.opn_script_uri} ${var.shell_script_obj.opn_version} ${var.shell_script_obj.wa_linux_version} ${var.shell_script_obj.opn_type} ${local.trusted_subnet_cidr} ${local.windows_subnet_cidr} ${var.shell_script_obj.public_ip_address} ${var.shell_script_obj.opn_sense_secondary_trusted_nic_ip}"
  })

  depends_on = [azurerm_linux_virtual_machine.opnsense]
}

# Outputs
output "untrusted_nic_ip" {
  value = azurerm_network_interface.untrusted.private_ip_address
}

output "trusted_nic_ip" {
  value = azurerm_network_interface.trusted.private_ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.opnsense.id
}
