resource "azurerm_public_ip" "pip-firewall" {
  name                = "pip-firewall"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"] # ["1", "2", "3"]
}

resource "azurerm_firewall" "firewall" {
  name                = "firewall"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = ["1"] # ["1", "2", "3"]
  firewall_policy_id  = azurerm_firewall_policy.firewall-policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-hub-firewall.id
    public_ip_address_id = azurerm_public_ip.pip-firewall.id
  }
}

module "diagnostic-setting-firewall" {
  source                     = "./modules/diagnostic-setting"
  target_resource_id         = azurerm_firewall.firewall.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
}
