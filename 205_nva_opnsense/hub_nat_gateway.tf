resource "azurerm_public_ip_prefix" "pip-prefix-nat-gateway" {
  name                = "pip-prefix-nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
  zones               = [1]
}

# resource "azurerm_public_ip" "pip-nat-gateway" {
#   name                = "pip-nat-gateway"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   # zones               = ["1"]
# }

resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1] # Only one Availability Zone can be defined.
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "association_pip_prefix_nat_gateway" {
  nat_gateway_id      = azurerm_nat_gateway.nat-gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.pip-prefix-nat-gateway.id
}

# resource "azurerm_nat_gateway_public_ip_association" "association" {
#   nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
#   public_ip_address_id = azurerm_public_ip.pip-nat-gateway.id
# }

resource "azurerm_subnet_nat_gateway_association" "subnet_natgw" {
  subnet_id      = azurerm_subnet.snet-untrusted.id
  nat_gateway_id = azurerm_nat_gateway.nat-gateway.id
}

output "pip_prefix_nat_gateway" {
  value = azurerm_public_ip_prefix.pip-prefix-nat-gateway.ip_prefix
}