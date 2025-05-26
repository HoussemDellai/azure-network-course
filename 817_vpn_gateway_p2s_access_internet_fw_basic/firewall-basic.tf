resource "azurerm_public_ip" "pip-firewall-transit" {
  name                = "pip-firewall-transit"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip-firewall-management" {
  name                = "pip-firewall-management"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name                = "firewall-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy-basic.id
  sku_tier            = "Basic"
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "config-transit"
    subnet_id            = azurerm_subnet.snet-firewall.id
    public_ip_address_id = azurerm_public_ip.pip-firewall-transit.id
  }

  management_ip_configuration {
    name                 = "config-mgmt"
    subnet_id            = azurerm_subnet.snet-firewall-management.id
    public_ip_address_id = azurerm_public_ip.pip-firewall-management.id
  }
}
