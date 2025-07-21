resource "azurerm_public_ip" "pip-firewall-hub02" {
  name                = "pip-firewall-hub02"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall-hub02" {
  name                = "firewall-hub02"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy-hub02.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub02.id
    public_ip_count = 1
  }
}