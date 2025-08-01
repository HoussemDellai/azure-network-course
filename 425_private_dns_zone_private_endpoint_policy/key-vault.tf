data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = "keyvault-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  enable_rbac_authorization     = true # seems that mounting storage account with key vault integration requires access policy, not RBAC
  public_network_access_enabled = true # should be false, but to avoid deploying through a Jumpbox VM in the VNET, we set it to false
}