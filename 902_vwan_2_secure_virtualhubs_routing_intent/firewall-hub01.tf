resource "azurerm_public_ip" "pip-firewall-hub01" {
  name                = "pip-firewall-hub01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall-hub01" {
  name                = "firewall-hub01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy-hub01.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub01.id
    public_ip_count = 1
  }
}