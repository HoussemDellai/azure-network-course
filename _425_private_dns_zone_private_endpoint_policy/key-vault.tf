data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = "keyvault-app-storage-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  enable_rbac_authorization     = true # seems that mounting storage account with key vault integration requires access policy, not RBAC
  public_network_access_enabled = true # should be false, but to avoid deploying through a Jumpbox VM in the VNET, we set it to false
}

# resource "azurerm_key_vault_secret" "secret-storage-account-sas" {
#   name         = "storage-account-sas-token"
#   value        = azurerm_storage_account.storage-account.primary_access_key
#   key_vault_id = azurerm_key_vault.keyvault.id

#   depends_on = [azurerm_role_assignment.role-key-vault-administrator]
# }

# resource "azurerm_role_assignment" "role-key-vault-secrets-user" {
#   scope                = azurerm_key_vault.keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_linux_web_app.webapp.identity.0.principal_id
# }

# resource "azurerm_role_assignment" "role-key-vault-administrator" {
#   scope                = azurerm_key_vault.keyvault.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }