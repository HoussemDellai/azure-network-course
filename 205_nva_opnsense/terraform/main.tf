# OPNsense Firewall Deployment - Terraform Version
# Converted from ARM template main.json

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Data source for resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Create Virtual Network (conditional)
resource "azurerm_virtual_network" "main" {
  count               = var.existing_virtual_network == "new" ? 1 : 0
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.vnet_address

  tags = {
    Environment = "OPNsense"
  }
}

# Create Untrusted Subnet
resource "azurerm_subnet" "untrusted" {
  count                = var.existing_virtual_network == "new" ? 1 : 0
  name                 = var.existing_untrusted_subnet_name != "" ? var.existing_untrusted_subnet_name : local.untrusted_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.untrusted_subnet_cidr]
}

# Create Trusted Subnet
resource "azurerm_subnet" "trusted" {
  count                = var.existing_virtual_network == "new" ? 1 : 0
  name                 = var.existing_trusted_subnet_name != "" ? var.existing_trusted_subnet_name : local.trusted_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.trusted_subnet_cidr]
}

# Create Windows Subnet (conditional)
resource "azurerm_subnet" "windows" {
  count                = var.existing_virtual_network == "new" && var.deploy_windows ? 1 : 0
  name                 = var.existing_windows_subnet != "" ? var.existing_windows_subnet : local.windows_vm_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.deploy_windows_subnet]
}

# Data sources for existing subnets
data "azurerm_subnet" "existing_untrusted" {
  count                = var.existing_virtual_network != "new" ? 1 : 0
  name                 = var.existing_untrusted_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "existing_trusted" {
  count                = var.existing_virtual_network != "new" ? 1 : 0
  name                 = var.existing_trusted_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "existing_windows" {
  count                = var.existing_virtual_network != "new" && var.deploy_windows ? 1 : 0
  name                 = var.existing_windows_subnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

# Public IP for OPNsense
resource "azurerm_public_ip" "opnsense" {
  name                = "${var.virtual_machine_name}-PublicIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = var.public_ip_address_sku

  tags = {
    Environment = "OPNsense"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "opnsense" {
  name                = "${var.virtual_machine_name}-NSG"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Load Balancers (Active-Active scenario)
module "external_load_balancer" {
  count  = var.scenario_option == "Active-Active" ? 1 : 0
  source = "./modules/load_balancer"

  name                = "External-LoadBalance"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  public_ip_id        = azurerm_public_ip.opnsense.id
  is_internal         = false
}

module "internal_load_balancer" {
  count  = var.scenario_option == "Active-Active" ? 1 : 0
  source = "./modules/load_balancer"

  name                      = "Internal-LoadBalance"
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.main.name
  is_internal               = true
  internal_subnet_id        = local.trusted_subnet_id
  depends_on                = [azurerm_virtual_network.main, azurerm_subnet.trusted]
}

# OPNsense Virtual Machines
module "opnsense_primary" {
  count  = var.scenario_option == "Active-Active" ? 1 : 0
  source = "./modules/opnsense_vm"

  vm_name                           = "${var.virtual_machine_name}-Primary"
  location                          = var.location
  resource_group_name               = data.azurerm_resource_group.main.name
  vm_size                           = var.virtual_machine_size
  untrusted_subnet_id               = local.untrusted_subnet_id
  trusted_subnet_id                 = local.trusted_subnet_id
  public_ip_id                      = azurerm_public_ip.opnsense.id
  nsg_id                            = azurerm_network_security_group.opnsense.id
  external_lb_backend_pool_id       = var.scenario_option == "Active-Active" ? module.external_load_balancer[0].backend_pool_id : ""
  internal_lb_backend_pool_id       = var.scenario_option == "Active-Active" ? module.internal_load_balancer[0].backend_pool_id : ""
  external_lb_nat_rule_id           = var.scenario_option == "Active-Active" ? module.external_load_balancer[0].nat_rules[0] : ""

  shell_script_obj = {
    opn_script_uri                    = var.opn_script_uri
    opn_version                       = var.opn_version
    wa_linux_version                  = var.wa_linux_version
    opn_type                          = "Primary"
    trusted_subnet_name               = local.trusted_subnet_full_name
    windows_subnet_name               = var.deploy_windows ? local.windows_subnet_full_name : ""
    public_ip_address                 = azurerm_public_ip.opnsense.ip_address
    opn_sense_secondary_trusted_nic_ip = var.scenario_option == "Active-Active" ? module.opnsense_secondary[0].trusted_nic_ip : ""
  }

  shell_script_name = var.shell_script_name
  temp_username     = local.temp_username
  temp_password     = local.temp_password

  depends_on = [
    azurerm_virtual_network.main,
    azurerm_subnet.untrusted,
    azurerm_subnet.trusted,
    module.opnsense_secondary
  ]
}

module "opnsense_secondary" {
  count  = var.scenario_option == "Active-Active" ? 1 : 0
  source = "./modules/opnsense_vm"

  vm_name                     = "${var.virtual_machine_name}-Secondary"
  location                    = var.location
  resource_group_name         = data.azurerm_resource_group.main.name
  vm_size                     = var.virtual_machine_size
  untrusted_subnet_id         = local.untrusted_subnet_id
  trusted_subnet_id           = local.trusted_subnet_id
  nsg_id                      = azurerm_network_security_group.opnsense.id
  external_lb_backend_pool_id = var.scenario_option == "Active-Active" ? module.external_load_balancer[0].backend_pool_id : ""
  internal_lb_backend_pool_id = var.scenario_option == "Active-Active" ? module.internal_load_balancer[0].backend_pool_id : ""
  external_lb_nat_rule_id     = var.scenario_option == "Active-Active" ? module.external_load_balancer[0].nat_rules[1] : ""

  shell_script_obj = {
    opn_script_uri                    = var.opn_script_uri
    opn_version                       = var.opn_version
    wa_linux_version                  = var.wa_linux_version
    opn_type                          = "Secondary"
    trusted_subnet_name               = local.trusted_subnet_full_name
    windows_subnet_name               = var.deploy_windows ? local.windows_subnet_full_name : ""
    public_ip_address                 = azurerm_public_ip.opnsense.ip_address
    opn_sense_secondary_trusted_nic_ip = ""
  }

  shell_script_name = var.shell_script_name
  temp_username     = local.temp_username
  temp_password     = local.temp_password

  depends_on = [
    azurerm_virtual_network.main,
    azurerm_subnet.untrusted,
    azurerm_subnet.trusted
  ]
}

# Single OPNsense VM (TwoNics scenario)
module "opnsense_single" {
  count  = var.scenario_option == "TwoNics" ? 1 : 0
  source = "./modules/opnsense_vm"

  vm_name             = var.virtual_machine_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  vm_size             = var.virtual_machine_size
  untrusted_subnet_id = local.untrusted_subnet_id
  trusted_subnet_id   = local.trusted_subnet_id
  public_ip_id        = azurerm_public_ip.opnsense.id
  nsg_id              = azurerm_network_security_group.opnsense.id

  shell_script_obj = {
    opn_script_uri                    = var.opn_script_uri
    opn_version                       = var.opn_version
    wa_linux_version                  = var.wa_linux_version
    opn_type                          = "TwoNics"
    trusted_subnet_name               = local.trusted_subnet_full_name
    windows_subnet_name               = var.deploy_windows ? local.windows_subnet_full_name : ""
    public_ip_address                 = ""
    opn_sense_secondary_trusted_nic_ip = ""
  }

  shell_script_name = var.shell_script_name
  temp_username     = local.temp_username
  temp_password     = local.temp_password

  depends_on = [
    azurerm_virtual_network.main,
    azurerm_subnet.untrusted,
    azurerm_subnet.trusted
  ]
}

# Windows VM (optional)
module "windows_vm" {
  count  = var.deploy_windows ? 1 : 0
  source = "./modules/windows_vm"

  vm_name             = "VM-Win11Client"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = local.windows_subnet_id
  admin_username      = var.win_username
  admin_password      = var.win_password

  depends_on = [
    azurerm_virtual_network.main,
    azurerm_subnet.windows,
    module.opnsense_primary,
    module.opnsense_secondary,
    module.opnsense_single
  ]
}
