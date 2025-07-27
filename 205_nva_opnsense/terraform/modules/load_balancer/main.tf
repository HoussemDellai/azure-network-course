# Load Balancer Module

variable "name" {
  description = "Load balancer name"
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

variable "public_ip_id" {
  description = "Public IP ID for external load balancer"
  type        = string
  default     = ""
}

variable "is_internal" {
  description = "Whether this is an internal load balancer"
  type        = bool
  default     = false
}

variable "internal_subnet_id" {
  description = "Subnet ID for internal load balancer"
  type        = string
  default     = ""
}

locals {
  is_external = !var.is_internal
}

# Load Balancer
resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = var.is_internal ? [1] : []
    content {
      name                          = "FW"
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = var.internal_subnet_id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = local.is_external ? [1] : []
    content {
      name                 = "FW"
      public_ip_address_id = var.public_ip_id
    }
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "OPNSense"
}

# Health Probe
resource "azurerm_lb_probe" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "HTTPs"
  protocol        = "Tcp"
  port            = 443
}

# Load Balancing Rule for Internal LB
resource "azurerm_lb_rule" "internal" {
  count                          = var.is_internal ? 1 : 0
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "Internal-HA-Port-Rule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "FW"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
  enable_floating_ip             = true
}

# Load Balancing Rule for External LB
resource "azurerm_lb_rule" "external" {
  count                          = local.is_external ? 1 : 0
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "RDP"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "FW"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
}

# Outbound Rule for External LB
resource "azurerm_lb_outbound_rule" "external" {
  count                   = local.is_external ? 1 : 0
  loadbalancer_id         = azurerm_lb.main.id
  name                    = "OutBound-OPNSense"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
    name = "FW"
  }
}

# NAT Rules for External LB (for management access)
resource "azurerm_lb_nat_rule" "primary_mgmt" {
  count                          = local.is_external ? 1 : 0
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "primary-nva-mgmt"
  protocol                       = "Tcp"
  frontend_port                  = 50443
  backend_port                   = 443
  frontend_ip_configuration_name = "FW"
}

resource "azurerm_lb_nat_rule" "secondary_mgmt" {
  count                          = local.is_external ? 1 : 0
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "secondary-nva-mgmt"
  protocol                       = "Tcp"
  frontend_port                  = 50444
  backend_port                   = 443
  frontend_ip_configuration_name = "FW"
}

# Outputs
output "id" {
  value = azurerm_lb.main.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.main.id
}

output "nat_rules" {
  value = local.is_external ? [
    azurerm_lb_nat_rule.primary_mgmt[0].id,
    azurerm_lb_nat_rule.secondary_mgmt[0].id
  ] : []
}

output "frontend_ip" {
  value = azurerm_lb.main.frontend_ip_configuration[0].private_ip_address
}
