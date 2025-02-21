resource "azurerm_public_ip" "pip-azfw" {
  name                = "pip-azfw-securehub-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall-hub-01" {
  name                = "fw-azfw-securehub-eus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy-hub-01.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub-01.id
    public_ip_count = 1
  }
}