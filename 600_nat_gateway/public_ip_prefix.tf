resource "azurerm_public_ip_prefix" "pip-prefix-nat-gateway" {
  name                = "pip-prefix-nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  ip_version          = "IPv4" # "IPv6"
  prefix_length       = 29     # between 0 (4,294,967,296 addresses) and 31 (2 addresses)
  zones               = ["1"]  # same zone as the NAT Gateway
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "natgw-pip-prefix-association" {
  nat_gateway_id      = azurerm_nat_gateway.nat-gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.pip-prefix-nat-gateway.id
}
