# resource "azurerm_public_ip_prefix" "pip-prefix-nat-gateway" {
#   name                = "pip-prefix-nat-gateway"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   prefix_length       = 30
#   zones               = [1]
# }

resource "azurerm_public_ip" "pip-out-natgw-1" {
  name                = "pip-out-natgw-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" # static IP allocation must be used when creating Standard SKU public IP addresses
  sku                 = "Standard"
  zones               = [1]
}

resource "azurerm_public_ip" "pip-out-natgw-2" {
  name                = "pip-out-natgw-02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" # static IP allocation must be used when creating Standard SKU public IP addresses
  sku                 = "Standard"
  zones               = [1]
}

resource "azurerm_public_ip" "pip-out-natgw-3" {
  name                = "pip-out-natgw-03"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static" # static IP allocation must be used when creating Standard SKU public IP addresses
  sku                 = "Standard"
  zones               = [1]
}

resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1]
}

# resource "azurerm_nat_gateway_public_ip_prefix_association" "association_pip_prefix_nat_gateway" {
#   nat_gateway_id      = azurerm_nat_gateway.nat-gateway.id
#   public_ip_prefix_id = azurerm_public_ip_prefix.pip-prefix-nat-gateway.id
# }

resource "azurerm_nat_gateway_public_ip_association" "association_pip1_nat_gateway" {
  nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
  public_ip_address_id = azurerm_public_ip.pip-out-natgw-1.id
}

resource "azurerm_nat_gateway_public_ip_association" "association_pip2_nat_gateway" {
  nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
  public_ip_address_id = azurerm_public_ip.pip-out-natgw-2.id
}

resource "azurerm_nat_gateway_public_ip_association" "association_pip3_nat_gateway" {
  nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
  public_ip_address_id = azurerm_public_ip.pip-out-natgw-3.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_natgw" {
  subnet_id      = azurerm_subnet.snet-vm.id
  nat_gateway_id = azurerm_nat_gateway.nat-gateway.id
}

# output "pip_prefix_nat_gateway" {
#   value = azurerm_public_ip_prefix.pip-prefix-nat-gateway.ip_prefix
# }

output "pip_out_natgw_1" {
  value = azurerm_public_ip.pip-out-natgw-1.ip_address
}

output "pip_out_natgw_2" {
  value = azurerm_public_ip.pip-out-natgw-2.ip_address
}

output "pip_out_natgw_3" {
  value = azurerm_public_ip.pip-out-natgw-3.ip_address
}